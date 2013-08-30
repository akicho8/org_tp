require "active_support/concern"

module RainTable
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def to_t(options = {})
        RainTable.generate(all.collect(&:attributes), options)
      end
    end

    def to_t(options = {})
      RainTable.generate(attributes, options)
    end
  end
end

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
    RainTable.generate(self, options)
  end
end

[Symbol, String, Numeric].each do |klass|
  klass.class_eval do
    def to_t(options = {})
      RainTable.generate([{self.class.name => self}], options)
    end
  end
end
