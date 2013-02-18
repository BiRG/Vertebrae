require 'net/http'
require 'thread'
require 'vertebrae/net/job'
require 'vertebrae/net/result'

include ::Net

module Vertebrae
  module Net
    class RequestProcessor

      public

      attr_accessor :base_address
      attr_accessor :maximum_concurrent_requests
      attr_accessor :maximum_request_count
      attr_accessor :minimum_request_interval

      def initialize()
        @finished = false
        @has_immediate_request = false
        @last_count = 0
        @last_time = Time.now
        @lock = Mutex.new()
        @maximum_concurrent_requests = 1
        @maximum_request_count = 1
        @minimum_request_interval = 1
        @queue = Queue.new()
        @workers = Array.new()
        start_master()
      end

      def concurrent?()
        return @workers.length > 0
      end

      def enqueue(command, parameters, &callback)
        job = Job.new(command, parameters, &callback)
        @queue.enq(job)
      end

      def finish()
        @finished = true
      end

      def finished?()
        return @finished
      end

      def has_jobs?()
        return !@queue.empty?
      end

      def request(command, parameters)
        @lock.synchronize do
          @has_immediate_request = true
        end
        uri = URI("http://eutils.ncbi.nlm.nih.gov/entrez/eutils")
        session = HTTP.new(uri.host, uri.port)
        job = Job.new(command, parameters)
        result = process(job, session)
        @lock.synchronize do
          @has_immediate_request = false
        end
        return result
      end

      def wait()
        until @queue.empty? do
          current_workers = nil
          @lock.synchronize do
            current_workers = @workers.clone()
          end
          current_workers.each do |worker|
            worker.join()
          end
        end
      end

      protected

      def create_workers()
        count = 0
        @lock.synchronize do
          if @queue.length < @maximum_concurrent_requests
            count = @queue.length - @workers.length
          else
            count = @maximum_concurrent_requests - @workers.length
          end
        end
        count.times do
          start_worker()
        end
      end

      def generate_uri(command, parameters)
        uri = "#{base_address}/#{command}?"
        parameters.each do |key, value|
          uri += "&#{key}=#{value}"
        end
        return URI(uri)
      end

      def limit_frequency()
        @lock.synchronize do
          delay = Time.now - @last_time
          if delay < @minimum_request_interval
            @last_count += 1
          else
            @last_count = 0
          end
          if @last_count == @maximum_request_count
            sleep((@minimum_request_interval - delay).ceil())
            @last_count = 0
          end
          @last_time = Time.now
        end
      end

      def process(job, session = nil)
        uri = generate_uri(job.command, job.parameters)
        request = HTTP::Post.new(uri.path)
        request.body = uri.query
        limit_frequency()
        begin
          response = session.request(request)
          result = Result.new(response)
        rescue StandardError, Timeout::Error => e
          result = Result.new(nil, true)
        end
        return result
      end

      def remove_workers()
        @workers.each.with_index do |worker, i|
          next if worker.alive?
          @workers.delete_at(i)
        end
      end

      def retrieve_job()
        job = nil
        unless @has_immediate_request || @queue.empty?
          job = @queue.deq()
        end
        return job
      end

      def start_master()
        master = Thread.new() do
          until @finished do
            sleep 1
            remove_workers()
            create_workers()
          end
        end
        @master = master
      end

      def start_worker()
        worker = Thread.new() do
          uri = URI("#{base_address}")
          session = HTTP.new(uri.host, uri.port)
          loop do
            job = nil
            @lock.synchronize do
              job = retrieve_job()
            end
            break unless job
            result = process(job, session)
            @lock.synchronize do
              job.callback.call(result) if job.has_callback?
            end
          end
        end
        @workers << worker
      end

    end
  end
end
