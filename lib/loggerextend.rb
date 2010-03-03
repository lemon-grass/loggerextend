module LoggerExtend
  require 'logger'

  # +levelname+:: the name of the new level to be defined, as a string
  # +before+::    the name of the existing level which +newlevel+ is to be inserted before, as a string
  # This method modifes the Logger class, defining a new method called +levelname+ (in lower case) which acts
  # similarly to the existing logging methods such as +debug+ and +warn+.
  def LoggerExtend.loggerextend(levelname, before)
    levelname.upcase!
    before.upcase!
    raise ArgumentError, "levelname must be less than 6 characters" unless levelname.length < 6
    raise ArgumentError, "levelname #{levelname} is already defined in Logger" if Logger.constants.index(levelname)
    raise ArgumentError, "levelname #{levelname.downcase} is already defined in Logger" if Logger.constants.index(levelname.downcase)

    levs = Logger::SEV_LABEL
    # exclude the "ANY" at the end, which is not really a level
    levs = levs[0..levs.length-1-1]
    # define a constant for our new level
    code = "#{levelname} = #{before}; "
    # write some code to increment the level constants following our new level
    levs.last(levs.length - levs.index(before)).each { |level|
      code << "#{level} += 1; "
    }
    #p code
    # modify the Logger class with our new code
    Logger.module_eval(code);

    # add our new level to the list of levels
    Logger::SEV_LABEL.insert(Logger::SEV_LABEL.index(before), levelname)

    # write a new routine to log messages at our new level
    code = "def #{levelname.downcase}(progname = nil, &block); add(#{levelname}, nil, progname, &block); end"
    #p code
    # modify the Logger class with our new code
    Logger.module_eval(code);
  end
end

