# ./spec/lib/salapi/client_spec.rb
require 'rspec'
require 'spec_helper'

include RSpec

RSpec.describe SalAPI do
  it 'requires sal_priv_key for a new instance' do
    expect { SalAPI::Client.new('privatekey' => nil) }.to raise_error(ArgumentError)
  end

  it 'requires sal_pub_key for a new instance' do
    expect { SalAPI::Client.new('publickey' => nil) }.to raise_error(ArgumentError)
  end

  it 'requires sal_url for a new instance' do
    expect { SalAPI::Client.new('sal_url' => nil) }.to raise_error(ArgumentError)
  end
end
