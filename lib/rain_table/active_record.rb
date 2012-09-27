require "active_support/concern"
require "active_support/lazy_load_hooks"

module RainTable
  module ActiveRecord
    extend ActiveSupport::Concern

    module ClassMethods
      def to_table(options = {})
        RainTable.generate(scoped.collect(&:attributes), options)
      end
    end

    def to_table(options = {})
      RainTable.generate([attributes], options)
    end
  end
end

ActiveSupport.on_load(:active_record) { include RainTable::ActiveRecord }

if $0 == __FILE__
  require "rain_table"
  require "active_record"
  ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")

  silence_stream(STDOUT) do
    ActiveRecord::Schema.define do
      suppress_messages do
        create_table :users do |t|
          t.string :name
          t.timestamps
        end
      end
    end
  end

  class User < ActiveRecord::Base
  end

  3.times{|i| User.create!(:name => i) }
  puts User.to_table
  puts User.first.to_table
  puts User.order(:id).reverse_order.limit(2).to_table
end
