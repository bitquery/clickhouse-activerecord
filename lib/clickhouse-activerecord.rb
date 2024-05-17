# frozen_string_literal: true

require 'clickhouse-activerecord/configuration'
require 'active_record/connection_adapters/clickhouse_adapter'

if defined?(Rails::Railtie)
  require 'clickhouse-activerecord/railtie'
  require 'clickhouse-activerecord/schema_dumper'
  require 'clickhouse-activerecord/tasks'
  ActiveRecord::Tasks::DatabaseTasks.register_task(/clickhouse/, "ClickhouseActiverecord::Tasks")
end

module ClickhouseActiverecord
  class << self
    def configuration
      @configuration ||= Configuration.new
    end

    def configure
      yield(configuration)
    end
  end
end
