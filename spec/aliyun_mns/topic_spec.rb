require 'spec_helper'

require_relative '../../lib/aliyun_mns/topic'

describe AliyunMns::Topic do
  it ".[] will create new queue instance" do
    topic = AliyunMns::Topic["aTopic"]
    expect(topic).not_to be_nil
    expect(topic.name).to eq("aTopic")
  end


  describe ".topics" do
    let(:xml_response) {
      <<-XML
            <?xml version="1.0" encoding="utf-8"?>
            <Topics xmlns="http://mns.aliyuncs.com/doc/v1/">
                <Topic>
                    <TopicURL>http://123456.mns.cn-hangzhou.aliyuncs.com/topics/aTopic</TopicURL>
                </Topic>
                <NextMarker>OTczNjU4MTcvYmRwejd6NXluby8yNjg0Mi9UZXN0VG9waWMtMy8w</NextMarker>
            </Topics>
      XML
    }

    it "find all topics" do
      expect(AliyunMns::Request).to receive(:get).with("/topics", mqs_headers: {}).and_return xml_response
      topics = AliyunMns::Topic.topics
      expect(topics.size).to eq(1)
      expect(topics[0].name).to eq("aTopic")
    end

    it "get topic attribute" do
      topic = AliyunMns::Topic["aTopic"].get_topic_attributes
      p topic
      expect(topic[:topic_name]).to eq("aTopic")
    end
  end

  describe "#create" do
    it "will create a new topic with default options" do
      expect(RestClient).to receive(:put) do |*args|
        path, body, headers = *args
        xml = Hash.from_xml(body)
        expect(xml["Topic"]["MaximumMessageSize"]).to eq("65536")
        expect(headers).not_to be_nil
      end
      AliyunMns::Topic["aTopic"].create
    end
  end

  describe "delete topic" do
    it "will delete a topic" do
      expect(RestClient).to receive(:delete) do |*args|
        path, headers = *args
        expect(headers).not_to be_nil
      end
      AliyunMns::Topic["aTopic"].delete
    end
  end

  describe "#subscribe" do
    it "will subscribe a topic" do
      expect(RestClient).to receive(:put) do |*args|
        path, body, headers = *args
        xml = Hash.from_xml(body)
        expect(xml["Subscription"]["Endpoint"]).to eq("http://Endpoint_url")
        expect(xml["Subscription"]["FilterTag"]).to eq("send-sms")
        expect(xml["Subscription"]["NotifyStrategy"]).to eq("BACKOFF_RETRY")
        expect(xml["Subscription"]["NotifyContentFormat"]).to eq("JSON")
        expect(headers).not_to be_nil
      end
      AliyunMns::Topic["atopic", "atopic-subscribe"].subscribe(
          {
              :Endpoint => "http://Endpoint_url",
              :FilterTag => "send-sms",
              :NotifyStrategy => "BACKOFF_RETRY",
              :NotifyContentFormat => "JSON"
          }
      )
    end

    it "will unsubscribe a topic" do
      expect(RestClient).to receive(:delete) do |*args|
        path, headers = *args
        expect(headers).not_to be_nil
      end
      AliyunMns::Topic["aopic", "atopic-subscribe"].unsubscribe
    end
  end

  describe "#messaage" do
    it "will publish message" do

      expect(RestClient).to receive(:put) do |*args|
        path, body, headers = *args
        xml = Hash.from_xml(body)
        expect(xml["Message"]["MessageTag"]).to eq("send-sms")
        expect(headers).not_to be_nil
      end

      AliyunMns::Topic["atopic"].publish_message(
          {
              :MessageBody => "test message",
              :MessageTag => "send-sms"
          }
      )
    end
  end
end
