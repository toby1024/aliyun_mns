# AliyunMns

aliyun mns 通过http api操作topic

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'aliyun_mns'
```
## Rails configuration
if you are going to use this gem in a rails environment. 
You need to create a configuration file at <RAILS_ROOT>/config/aliyun_mns.yml. 
In this way, you can use different set of topics for your development or production environments.

    development:
       access_key_id:       'ccess_key_id'
       access_key_secret:   'access_key_secret'
       endpoint:            '$id.mns.cn-hangzhou.aliyuncs.com'
    
    production:
       access_key_id:       'ccess_key_id'
       access_key_secret:   'access_key_secret'
       endpoint:            '$id.mns.cn-hangzhou.aliyuncs.com'
       
## Config in an application

At last you can also config the gem in place, by excute the following code before invoking and queue service.

    AliyunMns.configure do |config|
    
      config.access_key_id = "access_key_id"
      config.access_key_secret = "access_key_secret"
      config.endpoint = "$id.mns.cn-hangzhou.aliyuncs.com"
      
    end
    
And then execute:

    $ bundle install


# Usage
## about topic

create

    AliyunMns::Topic["aTopic"].create
    
delete
    
     AliyunMns::Topic["aTopic"].delete
    
find all topics
    
    AliyunMns::Topic.topics
    
get topic attributes
    
    request:
    topic = AliyunMns::Topic["topic_name"].get_topic_attributes

    response:
    # topic_name	主题名称
    # create_time	主题的创建时间，从 1970-1-1 00:00:00到现在的秒值
    # last_modify_time	修改主题属性信息的最近时间，从 1970-1-1 00:00:00 到现在的秒值
    # maximum_message_size	发送到该主题的消息体最大长度，单位为 Byte
    # message_retention_period	消息在主题中最长存活时间，从发送到该主题开始经过此参数指定的时间后，不论消息是否被成功推送给用户都将被删除，单位为秒
    # message_count	当前该主题中消息数目
    # logging_enabled	是否开启日志管理功能，True表示启用，False表示停用

    {
        :topic_name=>"topic_name", 
        :create_time=>"1472442458", 
        :last_modify_time=>"1472442458", 
        :maximum_message_size=>"65536", 
        :message_retention_period=>"86400", 
        :message_ount=>"5", 
        :logging_enabled=>"False"
    }

    
subscribe
    
    AliyunMns::Topic["atopic", "atopic-subscribe"].subscribe(
              {
                  :Endpoint => "http://Endpoint_url",
                  :FilterTag => "send-sms",
                  :NotifyStrategy => "BACKOFF_RETRY",
                  :NotifyContentFormat => "JSON"
              }
          )

unsubscribe

    AliyunMns::Topic["aopic", "atopic-subscribe"].unsubscribe
    
publish message

    AliyunMns::Topic["atopic"].publish_message(
              {
                  :MessageBody => "test message",
                  :MessageTag => "publish_message"
              }
          )
    
## about queue

create

    AliyunMns::Queue["aqueue"].create
    
delete
    
     AliyunMns::Queue["aqueue"].delete
     
send message

    AliyunMns::Queue["aqueue"].send_message("send_message")
    
receive message

    message = AliyunMns::Queue["aqueue"].receive_message

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/zhangbin/aliyun_mns. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

# aliyun_mns
