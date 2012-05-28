require 'httparty'

module SalesforceApi
  module Request
    def self.do_request (verb, target, headers, data=nil)
      case verb
      when 'GET'
        return resp = HTTParty.get(target, :headers => headers)
      when 'POST'
        return resp = HTTParty.post(target, :body => data, :headers => headers)
      when 'DELETE'
        return resp = HTTParty.delete(target, :headers => headers)
      end
    end
  end
end