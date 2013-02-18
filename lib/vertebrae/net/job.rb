module Vertebrae
  module Net
    class Job

      public

      attr_reader :callback
      attr_reader :command
      attr_reader :parameters

      def initialize(command, parameters, &callback)
        @callback = callback
        @command = Marshal.load(Marshal.dump(command))
        @parameters = Marshal.load(Marshal.dump(parameters))
      end

      def has_callback?()
        return @callback != nil
      end

    end
  end
end