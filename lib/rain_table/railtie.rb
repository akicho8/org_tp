module RainTable
  class Railtie < Rails::Engine
    initializer "rain_table" do
      require "rain_table/active_record"
      ActiveSupport.on_load(:active_record) do
        include RainTable::ActiveRecord
      end
    end
  end
end
