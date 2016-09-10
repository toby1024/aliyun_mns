module AliyunMns
  class Notification
    attr_reader :message, :message_id, :message_MD5, :message_tag, :publish_time, :subscriber, :subscription_name,
                :topic_name, :topic_owner, :message_format, :message_controller, :action, :send_record

    def initialize(content_hash)
      @message_id = content_hash["MessageId"]
      @message_MD5 = content_hash["MessageMD5"]
      @message = content_hash["Message"]
      @message_tag = content_hash["MessageTag"]
      @publish_time = content_hash["PublishTime"]
      @subscriber = content_hash["Subscriber"]
      @subscription_name = content_hash["SubscriptionName"]
      @topic_name = content_hash["TopicName"]
      @topic_owner = content_hash["TopicOwner"]
      @message_format = content_hash["format"]
      @message_controller = content_hash["Controller"]
      @action = content_hash["Action"]
      @send_record = content_hash["SendRecord"]
    end
  end
end