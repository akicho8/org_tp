module OrgTp
  class Railtie < Rails::Railtie
    initializer 'org_tp' do
      ActiveSupport.on_load(:active_record) do
        include OrgTp::ActiveRecord

        ::ActiveRecord::Result.class_eval do
          def to_t(**options)
            OrgTp.generate(collect(&:to_h), options)
          end
        end
      end

      if defined?(Mongoid::Document)
        Mongoid::Document.include(OrgTp::ActiveRecord)
      end
    end
  end
end
