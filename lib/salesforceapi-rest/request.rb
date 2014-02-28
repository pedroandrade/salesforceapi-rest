require 'httparty'
require 'cgi'

module SalesforceApi
  module Request
    def self.do_request (verb, target, headers, data=nil)
      case verb
      when 'GET'
        return resp = HTTParty.get(CGI::unescape(target), :headers => headers)
      when 'POST'
        return resp = HTTParty.post(CGI::unescape(target), :body => data, :headers => headers)
      when 'PATCH'
        return resp = HTTParty.patch(CGI::unescape(target), :body => data, :headers => headers)
      when 'DELETE'
        return resp = HTTParty.delete(CGI::unescape(target), :headers => headers)
      end
    end
  end
end
