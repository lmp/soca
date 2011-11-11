require 'json'
require 'typhoeus'
require 'base64'
require 'mime/types'
require 'logger'

$LOAD_PATH.unshift(File.expand_path(File.join(File.dirname(__FILE__))))

module Soca
  VERSION = File.read(File.expand_path("../VERSION", File.dirname(__FILE__))).chomp
  autoload :Pusher, 'soca/pusher'
  autoload :CLI, 'soca/cli'
  autoload :Plugin, 'soca/plugin'
  autoload :BuildHelpers, 'soca/build_helpers'

  class << self
    attr_accessor :debug
  end

  def self.logger=(logger)
    @logger = logger
  end

  def self.logger
    @logger ||= LOGGER if defined?(LOGGER)
    if !@logger
      @logger           = Logger.new(STDOUT)
      @logger.level     = Logger::ERROR
      @logger.formatter = Proc.new {|s, t, n, msg| "#{msg}\n"}
      @logger
    end
    @logger
  end
end
