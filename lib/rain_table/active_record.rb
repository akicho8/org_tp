require "active_support/concern"
require "active_support/lazy_load_hooks"

module RainTable
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def to_table(options = {})
        RainTable.generate(all.collect(&:attributes), options)
      end
    end

    def to_table(options = {})
      RainTable.generate([attributes], options)
    end
  end
end

# ActiveSupport.on_load(:active_record) { include RainTable::ActiveRecord }
