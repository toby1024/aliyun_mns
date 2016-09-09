module AliyunMns
  class Queue
    require_relative 'message'
    attr_reader :name

    delegate :to_s, to: :name

    class << self
      def [] name
        Queue.new(name)
      end

      def queues(opts = {})
        mqs_options = {query: "x-mns-prefix", offset: "x-mns-marker", size: "x-mns-ret-number"}
        mqs_headers = opts.slice(*mqs_options.keys).reduce({}) { |mqs_headers, item| k, v = *item; mqs_headers.merge!(mqs_options[k] => v) }
        response = Request.get("/queues", mqs_headers: mqs_headers)
        Hash.xml_array(response, "Queues", "Queue").collect { |item| Queue.new(URI(item["QueueURL"]).path.sub!(/^\/queues\//, "")) }
      end
    end

    def initialize(name)
      @name = name
    end

    #创建队列
    def create(opts = {})
      Request.put(queue_path) do |request|
        msg_options = {
            :VisibilityTimeout => 30,
            :DelaySeconds => 0,
            :MaximumMessageSize => 65536,
            :MessageRetentionPeriod => 345600,
            :PollingWaitSeconds => 0
        }.merge(opts)
        request.content(:Queue, msg_options)
      end
    end

    #删除队列
    def delete
      Request.delete(queue_path)
    end

    #发送消息
    def send_message(message, opts = {})
      Request.post(messages_path) do |request|
        msg_options = {
            :DelaySeconds => 0,
            :Priority => 8
        }.merge(opts)
        request.content(:Message, msg_options.merge(:MessageBody => message.to_s))
      end
    end

    #消费消息
    def receive_message(wait_seconds = nil)
      request_opts = {}
      request_opts.merge!(params: {waitseconds: wait_seconds}) if wait_seconds
      result = Request.get(messages_path, request_opts)
      Message.new(self, result)
    end

    def queue_path
      "/queues/#{name}"
    end

    def messages_path
      "/queues/#{name}/messages"
    end

  end
end