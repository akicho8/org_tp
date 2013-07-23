require_relative "rain_table/version"
require_relative "rain_table/rain_table"
require_relative "rain_table/compatible"

module Kernel
  def tt(object, options = {})
    object.to_t(options).display
  end
end

class Array
  def to_t(options = {})
    RainTable.generate(self, options)
  end
end

class Hash
  def to_t(options = {})
    RainTable.generate([self], options)
  end
end

require_relative "rain_table/railtie" if defined?(Rails)
