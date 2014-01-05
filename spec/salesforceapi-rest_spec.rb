require 'spec_helper'

describe Salesforceapi::Rest::Client do

  let(:client) { SalesforceApi::Rest::Client.new("my_token", "salesforce.com") }

  it "should get the resources information" do
    SalesforceApi::Request.should_receive(:do_request).with("GET", "salesforce.com/services/data/v21.0",
      headers, nil).and_return(mock_get)
    @client.resources
  end


  protected

  def headers
    {
      "Authorization" => "OAuth " + "my_token",
      "content-Type" => 'application/json'
    }
  end

  def mock_get
    ActiveSupport::JSON.stub(:decode).and_return("")
    get_request = mock("get request")
    get_request.should_receive(:code).and_return(200)
    get_request.should_receive(:body).and_return("")
    get_request.should_receive(:success?).and_return(true)
    get_request
  end
end
