require 'spec_helper'

describe AliyunMns::Request do

  describe "Reqest methods" do
    specify "get" do
      expect(RestClient).to receive(:get) do |*args|
        path, headers = *args
        expect(headers).to be_a(Hash)
      end

      AliyunMns::Request.get("/")
    end
  end

end
