require 'logger'
require 'loggerextend'

begin
  LoggerExtend.loggerextend("ERROR", "WARN")
rescue Exception => e
  puts "Can't extend with ERROR: " + e.message
end

puts "Logger::WARN is " + Logger::WARN.to_s
puts "Logger::ERROR is " + Logger::ERROR.to_s

LoggerExtend.loggerextend("NOTE", "WARN")

puts "After extend"
puts "Logger::NOTE is " + Logger::NOTE.to_s
puts "Logger::WARN is " + Logger::WARN.to_s
puts "Logger::ERROR is " + Logger::ERROR.to_s
puts "Logger::SEV_LABEL is " + Logger::SEV_LABEL.inspect

$log = Logger.new(STDOUT)
$log.debug("this is a debug")
$log.info("this is a info")
$log.note("this is a note")
$log.warn("this is a warn")
$log.error("this is a error")
$log.fatal("this is a fatal")

