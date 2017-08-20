require 'org_tp/version'
require 'org_tp/generator'
require 'org_tp/core_ext'

if defined?(Rails)
  require 'org_tp/railtie'
else
  if defined?(ActiveSupport)
    ActiveSupport.on_load(:active_record) do
      include OrgTp::ActiveRecord

      ActiveRecord::Result.class_eval do
        def to_t(**options)
          OrgTp.generate(collect(&:to_h), options)
        end
      end
    end
  end
  if defined?(Mongoid::Document)
    Mongoid::Document.include(OrgTp::ActiveRecord)
  end
end

if defined?(Tapp)
  module Tapp::Printer
    class Tp < Base
      def print(*args)
        tp *args
      end
    end

    register :tp, Tp
  end
end
