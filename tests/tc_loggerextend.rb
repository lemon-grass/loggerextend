$LOAD_PATH << File.expand_path(File.join(File.dirname(__FILE__), '../lib'))
require 'loggerextend'
require 'logger'
require 'test/unit'
require 'tempfile'

class TestLoggerExtend < Test::Unit::TestCase

  def setup
    @logger = Logger.new(nil)
    @filename = __FILE__ + ".#{$$}"
  end

  def teardown
    unless $DEBUG
      File.unlink(@filename) if File.exist?(@filename)
    end
  end

  class Log
    attr_reader :label, :datetime, :pid, :severity, :progname, :msg
    def initialize(line)
      /\A(\w+), \[([^#]*)#(\d+)\]\s+(\w+) -- (\w*): ([\x0-\xff]*)/ =~ line
      @label, @datetime, @pid, @severity, @progname, @msg = $1, $2, $3, $4, $5, $6
    end
  end

  def log_add(logger, severity, msg, progname = nil, &block)
    log(logger, :add, severity, msg, progname, &block)
  end

  def log(logger, msg_id, *arg, &block)
    Log.new(log_raw(logger, msg_id, *arg, &block))
  end

  def log_raw(logger, msg_id, *arg, &block)
    logdev = Tempfile.new(File.basename(__FILE__) + '.log')
    logger.instance_eval { @logdev = Logger::LogDevice.new(logdev) }
    logger.__send__(msg_id, *arg, &block)
    logdev.open
    msg = logdev.read
    logdev.close
    msg
  end

  def test_extender
    assert_raise(ArgumentError) { LoggerExtend.loggerextend("FISHES", "DEBUG") }
    assert_raise(ArgumentError) { LoggerExtend.loggerextend("WARN", "DEBUG") }
  end

  def test_adjust_levels
    existing = "WARN"
    newname = "NOTE"
    ex_level = eval("Logger::" + existing)
    LoggerExtend.loggerextend(newname, existing)
    assert_equal(ex_level + 1, eval("Logger::" + existing))
  end

  def test_function
    logger = Logger.new(nil)
    logger.progname = "my_progname"

    log = log(logger, :warn, "custom_progname") { "msg" }
    assert_equal("msg\n", log.msg)
    assert_equal("custom_progname", log.progname)
    assert_equal("WARN", log.severity)
    assert_equal("W", log.label)
    #
    LoggerExtend.loggerextend("MARK", "WARN")
    #
    log = log(logger, :mark, "custom_progname") { "msg" }
    assert_equal("msg\n", log.msg)
    assert_equal("custom_progname", log.progname)
    assert_equal("MARK", log.severity)
    assert_equal("M", log.label)
    #
  end
end
