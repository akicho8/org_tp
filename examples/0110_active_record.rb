$LOAD_PATH << "../lib"
require "active_record"
require "rain_table"

ActiveRecord::Base.include(RainTable::ActiveRecord)
ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
  end
end

class User < ActiveRecord::Base
end

["alice", "bob"].each{|name| User.create!(:name => name) }

tt User
tt User.first
tt User.limit(1)
# >> +----+-------+
# >> | id | name  |
# >> +----+-------+
# >> |  1 | alice |
# >> |  2 | bob   |
# >> +----+-------+
# >> +------+-------+
# >> | id   |     1 |
# >> | name | alice |
# >> +------+-------+
# >> +----+-------+
# >> | id | name  |
# >> +----+-------+
# >> |  1 | alice |
# >> +----+-------+
