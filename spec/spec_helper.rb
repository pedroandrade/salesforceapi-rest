$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
$:.unshift File.expand_path('../../lib/salesforceapi-rest', __FILE__)

require 'rspec'
require 'rack/test'
require 'salesforceapi-rest'

RSpec.configure do |config|

end