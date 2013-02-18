module Vertebrae
  module Net
    class Result

      public

      attr_reader :response
      attr_reader :exception

      def initialize(response, error = false)
        @response = response
        @error = error
      end

      def error?()
        return @error
      end

    end
  end
end