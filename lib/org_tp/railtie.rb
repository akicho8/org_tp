module OrgTp
  class Railtie < Rails::Railtie
    initializer 'org_tp' do
      ActiveSupport.on_load(:active_record) do
        include OrgTp::ActiveRecord
      end

      if defined?(Mongoid::Document)
        Mongoid::Document.include(OrgTp::ActiveRecord)
      end
    end
  end
end
