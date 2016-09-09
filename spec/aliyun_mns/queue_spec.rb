require 'spec_helper'

require_relative '../../lib/aliyun_mns/queue'

describe AliyunMns::Queue do

  describe ".queues" do
    let(:xml_response) {
      <<-XML
            <?xml version="1.0" encoding="UTF-8"?>
            <Queues xmlns="http://mns.aliyuncs.com/doc/v1/">
                <Queue>
                    <QueueURL>http://123456.mns.cn-hangzhou.aliyuncs.com/queues/aqueue</QueueURL>
                </Queue>
                <NextMarker>123456</NextMarker>
            </Queues>
      XML
    }
    it "find all queues" do
      expect(AliyunMns::Request).to receive(:get).with("/queues", mqs_headers: {}).and_return xml_response
      queues = AliyunMns::Queue.queues
      expect(queues.size).to eq(1)
      expect(queues[0].name).to eq("aqueue")
    end
  end

  describe "create queue" do
    it "will create a queue" do
      expect(RestClient).to receive(:put) do |*args|
        path, body, headers = *args
        xml = Hash.from_xml(body)
        expect(xml["Queue"]["MaximumMessageSize"]).to eq("65536")
        expect(headers).not_to be_nil
      end
      AliyunMns::Queue["aqueue"].create
    end
  end

  describe "delete queue" do
    it "will delete a queue" do
      expect(RestClient).to receive(:delete) do |*args|
        path, headers = *args
        expect(headers).not_to be_nil
      end
      AliyunMns::Queue["aqueue"].delete
    end
  end

  describe "send message" do
    it "send message" do
      expect(RestClient).to receive(:post) do |*args|
        path, body, headers = *args
        xml = Hash.from_xml(body)
        p xml
        expect(xml["Message"]["MessageBody"]).to eq("send_message")
      end
      AliyunMns::Queue["aqueue"].send_message("send_message")
    end
  end

  describe "receive_message" do
    let(:xml_response) {
      <<-XML
     <?xml version="1.0" encoding="UTF-8"?>
        <Message xmlns="http://mns.aliyuncs.com/doc/v1/">
            <MessageId>5F290C926D472878-2-14D9529A8FA-200000001</MessageId>
            <ReceiptHandle>1-ODU4OTkzNDU5My0xNDMyNzI3ODI3LTItOA==</ReceiptHandle>
            <MessageBodyMD5>C5DD56A39F5F7BB8B3337C6D11B6D8C7</MessageBodyMD5>
            <MessageBody>This is a test message</MessageBody>
            <EnqueueTime>1250700979248</EnqueueTime>
            <NextVisibleTime>1250700799348</NextVisibleTime>
            <FirstDequeueTime>1250700779318</FirstDequeueTime >
            <DequeueCount>1</DequeueCount >
            <Priority>8</Priority>
        </Message>
      XML
    }
    it "will receive message from a queue" do
      expect(AliyunMns::Request).to receive(:get).with("/queues/aqueue/messages", {}).and_return xml_response

      message = AliyunMns::Queue["aqueue"].receive_message
      expect(message).not_to be_nil
      expect(message.id).to eq("5F290C926D472878-2-14D9529A8FA-200000001")
      expect(message.body).to eq("This is a test message")
      expect(message.body_md5).to eq("C5DD56A39F5F7BB8B3337C6D11B6D8C7")
      expect(message.receipt_handle).to eq("1-ODU4OTkzNDU5My0xNDMyNzI3ODI3LTItOA==")
      expect(message.enqueue_at).to eq(Time.at(1250700979248/1000.0))
      expect(message.first_enqueue_at).to eq(Time.at(1250700779318/1000.0))
      expect(message.next_visible_at).to eq(Time.at(1250700799348/1000.0))
      expect(message.dequeue_count).to eq(1)
      expect(message.priority).to eq(8)
    end
  end
end
