require 'httparty'
require 'cgi'

module SalesforceApi
  module Request

    def get_resquest(target, headers)
       HTTParty.get(CGI::unescape(target), headers: headers)
    end

    def post_request(target, headers, attributes = {})
      data = ActiveSupport::JSON::encode(attributes)
      HTTParty.post(CGI::unescape(target), body: data, headers: headers)
    end

    def delete(target, headers)
      HTTParty.delete(CGI::unescape(target), headers: headers)
    end
  end
end
