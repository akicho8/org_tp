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
    if object.respond_to?(:to_t)
      object.to_t(options).display
    else
      RainTable.generate([{object.class.name => object}], {:header => false}.merge(options)).display
    end
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
      RainTable.generate([{self.class.name => self}], {:header => false}.merge(options))
    end
  end
end
