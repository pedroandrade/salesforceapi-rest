require 'spec_helper'

describe Salesforceapi::Rest::Client do

  let(:client) { Salesforceapi::Rest::Client.new("1234123", "12341512", "1234123", "1234125") }

  it "should get the resources information" do
    SalesforceApi::Request.should_receive(:do_request).with("POST", "https://login.salesforce.com/services/oauth2/token?grant_type=refresh_token&client_id=00DG0000000jW2VMAU&client_secret=salesforce.com&refresh_token=1234123", {"content-Type"=>"application/json"}, nil).and_return(mock_get)
    client.resources
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
