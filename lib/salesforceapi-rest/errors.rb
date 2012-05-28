module SalesforceApi
  module Errors

    class ApiError < RuntimeError

      attr_accessor :http_code

      def initialize(message, http_code)
        super message
        @http_code = http_code
      end
    end

    class RuntimeError < ApiError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 401, Session ID or Auth token expired
    class AuthenticationError < ApiError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 400, Request cannot be understood, because the JSON
    # or XML body has an error
    class RequestError < ApiError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 403, Request cannot be understood, because the JSON
    # or XML body has an error
    class RequestRefusedError < ApiError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 404, Requested resource cannot be found. Check URI for error.
    class ResourceNotFoundError < ApiError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 405, The method specified in the Request-Line is not allowed.
    class MethodError < ApiError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 415. The entity specified in the request is in a format
    # that is supported by the specified resource for the specified method.
    class EntityError < ApiError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    # Error for HTTP code 500, Force.com Internal Server error
    class Platformrror < ApiError
      def initialize(message, http_code)
        super(message, http_code)
      end
    end

    class ErrorManager
      def self.raise_error(message, http_code)
        case http_code
        when 400
          raise SalesforceApi::Errors::RequestError.new(message, http_code)
        when 401
          raise SalesforceApi::Errors::AuthenticationError.new(message, http_code)
        when 403
          raise SalesforceApi::Errors::RequestError.new(message, http_code)
        when 404
          raise SalesforceApi::Errors::ResourceNotFoundError.new(message, http_code)
        when 405
          raise SalesforceApi::Errors::MethodError.new(message, http_code)
        when 415
          raise SalesforceApi::Errors::EntityError.new(message, http_code)
        when 500
          raise SalesforceApi::Errors::PlatformError.new(message, http_code)
        else
          raise SalesforceApi::Errors::RuntimeError.new(message, http_code)
        end
      end
    end
  end
end