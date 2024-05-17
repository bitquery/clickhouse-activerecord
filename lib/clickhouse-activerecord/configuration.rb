module ClickhouseActiverecord
  class Configuration
    attr_accessor :read_timeout, :write_timeout, :open_timeout

    def initialize
      @read_timeout = 60
      @write_timeout = 60
      @open_timeout = 60
    end
  end
end