module RainTable
  class Railtie < Rails::Railtie
    initializer "rain_table" do
      ActiveSupport.on_load(:active_record) do
        include RainTable::ActiveRecord
      end

      if defined?(Mongoid::Document)
        Mongoid::Document.include(RainTable::ActiveRecord)
      end
    end
  end
end
