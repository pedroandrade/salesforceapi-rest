require 'httparty'
require "salesforceapi-rest/errors"
require 'cgi'

module SalesforceApi
  module Request

    def get(target, headers)
      verify_response HTTParty.get(
         CGI::unescape(target),
         headers: headers
      )
    end

    def post(target, headers, attributes = {})
      data = ActiveSupport::JSON::encode(attributes)

      verify_response HTTParty.post(
        CGI::unescape(target),
        body: data,
        headers: headers
      )
    end

    def delete(target, headers)
      verify_response HTTParty.delete(
        CGI::unescape(target),
        headers: headers
      )
    end

    private

      def verify_response(response)
        if response.code =~ /2\d\d/
          ActiveSupport::JSON.decode(response.body)
        else
          msg = ActiveSupport::JSON.decode(response.body)[0]["message"]
          SalesforceApi::Errors::ErrorManager.raise_error(
            "HTTP Response: #{response.code} : message",
            resp.code
          )
        end
      end
  end
end
