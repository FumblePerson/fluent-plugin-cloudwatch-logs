require 'test/unit'
require 'fluent/test'

require 'aws-sdk-core'

module CloudwatchLogsTestHelper
  private
  def logs
    @logs ||= Aws::CloudWatchLogs.new
  end

  def log_group_name
    @log_group_name ||= "fluent-plugin-cloudwatch-test-#{Time.now.to_f}"
  end

  def log_stream_name
    if !@log_stream_name
      new_log_stream
    end
    @log_stream_name
  end

  def new_log_stream
    @log_stream_name = Time.now.to_f.to_s
  end

  def clear_log_group
    logs.delete_log_group(log_group_name: log_group_name)
  rescue Aws::CloudWatchLogs::Errors::ResourceNotFoundException
    # pass
  end

  def create_log_stream
    begin
      logs.create_log_group(log_group_name: log_group_name)
    rescue Aws::CloudWatchLogs::Errors::ResourceAlreadyExistsException
      # pass
    end

    begin
      logs.create_log_stream(log_group_name: log_group_name, log_stream_name: log_stream_name)
    rescue Aws::CloudWatchLogs::Errors::ResourceAlreadyExistsException
      # pass
    end
  end

  def get_log_events
    logs.get_log_events(log_group_name: log_group_name, log_stream_name: log_stream_name).events
  end

  def put_log_events(events)
    args = {
      log_events: events,
      log_group_name: log_group_name,
      log_stream_name: log_stream_name,
    }
    logs.put_log_events(args)
  end
end

