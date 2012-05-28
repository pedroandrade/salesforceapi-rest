require "salesforceapi-rest/version"
require "salesforceapi-rest/sobject"
require "salesforceapi-rest/request"
require "salesforceapi-rest/errors"
require 'net/https'
require 'net/http'
require 'active_resource'
require 'httparty'

module SalesforceApi
  module Rest
    class Client
      include HTTParty
      extend SalesforceApi::Request

      base_uri "https://na7.salesforce.com"
      default_params :output => 'json'
      format :json
      @@ssl_port = 443

      # set header for httparty
      def self.set_headers (auth_setting)
        headers (auth_setting)
      end

      def initialize(oauth_token, instance_uri, api_version = "v21.0")
        @oauth_token = oauth_token
        @instance_uri = instance_uri
        @api_version = api_version ? api_version : "v21.0"  #take a dynamic api server version
        @full_url = instance_uri + "/services/data/#{api_version}/sobjects"
        @ssl_port = 443  # TODO, right SF use port 443 for all HTTPS traffic.


        # To be used by HTTParty
        @auth_header = {
          "Authorization" => "OAuth " + @oauth_token,
          "content-Type" => 'application/json'
        }
        # either application/xml or application/json
        self.class.base_uri @instance_uri

      end


      def create(object, attributes)

        path = "/services/data/#{@api_version}/sobjects/#{object}/"
        target = @instance_uri + path

        data = ActiveSupport::JSON::encode(attributes)

        resp = SalesforceApi::Request.do_request("POST", target, @auth_header, data)

        # HTTP code 201 means it was successfully saved.
        if resp.code != 201
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          SalesforceApi::Errors::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code)
        else
          return ActiveSupport::JSON.decode(resp.body)
        end

      end

      def describe(object)
        path = "/services/data/#{@api_version}/sobjects/#{object}/describe"
        target = @instance_uri + path

        resp = SalesforceApi::Request.do_request("GET", target, @auth_header, nil)
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          SalesforceApi::Errors::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code)
        else
          return ActiveSupport::JSON.decode(resp.body)
        end
      end

      def resources
        path = "/services/data/#{@api_version}"
        target = @instance_uri + path

        resp = SalesforceApi::Request.do_request("GET", target, @auth_header, nil)
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)[0]["message"]
          SalesforceApi::Errors::ErrorManager.raise_error("HTTP code " + resp.code.to_s + ": " + message, resp.code)
        else
          return ActiveSupport::JSON.decode(resp.body)
        end
      end
    end
  end
end
