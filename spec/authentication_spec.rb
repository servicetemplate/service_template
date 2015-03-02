require 'spec_helper'
require 'service_template/authentication'

describe ServiceTemplate::Authentication do
  context '#password_header' do
    it "returns a password hash for the request header" do
      ENV['HEADER_PASSWORD'] = 'foo'
      expect(ServiceTemplate::Authentication.password_header.class).to eq(Hash)
      expect(ServiceTemplate::Authentication.password_header).to eq('Password' => 'foo')
    end

    it 'raises when the HEADER_PASSWORD env var is not defined' do
      ENV['HEADER_PASSWORD'] = nil
      expect{ServiceTemplate::Authentication.password_header}.to raise_error
    end
  end
end
