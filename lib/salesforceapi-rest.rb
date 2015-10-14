require "salesforceapi-rest/version"
require "salesforceapi-rest/request"
require "salesforceapi-rest/errors"
require 'net/https'
require 'net/http'
require 'active_resource'
require 'httparty'
require 'builder'
require 'crack/xml'
require 'cgi'

module Salesforceapi
  module Rest
    class Client
      include HTTParty
      include SalesforceApi::Request

      base_uri "https://na7.salesforce.com"
      default_params :output => 'json'
      format :json
      @@ssl_port = 443

      # set header for httparty
      def self.set_headers (auth_setting)
        headers (auth_setting)
      end

      def initialize(refresh_token, metadata_uri, client_id, client_secret)
        @refresh_token = refresh_token
        @client_id = client_id
        @client_secret = client_secret
        @metadata_uri = metadata_uri
        @api_version = "v21.0"
        @ssl_port = 443  # TODO, right SF use port 443 for all HTTPS traffic.

        config_authorization!
      end

      def create(object, attributes)
        path = "/services/data/#{@api_version}/sobjects/#{object}/"
        target = @instance_uri + path

        post(target, @auth_header, attributes)
      end

      def describe(object)
        path = "/services/data/#{@api_version}/sobjects/#{object}/describe"
        target = @instance_uri + path

        get(target, @auth_header)
      end

      def resources
        path = "/services/data/#{@api_version}"
        target = @instance_uri + path

        get(target, @auth_header)
      end

      def config_authorization!
        target = CGI::unescape("https://login.salesforce.com/services/oauth2/token?grant_type=refresh_token&client_id=#{@client_id}&client_secret=#{@client_secret}&refresh_token=#{@refresh_token}")
        resp = SalesforceApi::Request.do_request("POST", target, {"content-Type" => 'application/json'}, nil)
        if (resp.code != 200) || !resp.success?
          message = ActiveSupport::JSON.decode(resp.body)["error_description"]
          SalesforceApi::Errors::ErrorManager.raise_error(message, 401)
        else
          response = ActiveSupport::JSON.decode(resp.body)
        end
        @instance_uri = response['instance_url']
        @access_token = response['access_token']
        @auth_header = {
          "Authorization" => "OAuth " + @access_token,
          "content-Type" => 'application/json'
        }
      end
    end
  end
end
