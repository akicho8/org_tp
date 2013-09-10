# -*- coding: utf-8 -*-
$LOAD_PATH << "../lib"
require "active_record"
require "rain_table"

tt 1
tt "foo"
tt :foo
tt({:id => 1, :name => "alice"})
tt [{:id => 1, :name => "alice"}, {:id => 2, :name => "bob"}]

ActiveRecord::Base.send(:include, RainTable::ActiveRecord)
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

puts [{:id => 1, :name => "alice"}, {:id => 2, :name => "bob"}].to_t

# >> +---+
# >> | 1 |
# >> +---+
# >> +-----+
# >> | foo |
# >> +-----+
# >> +-----+
# >> | foo |
# >> +-----+
# >> +------+-------+
# >> | id   |     1 |
# >> | name | alice |
# >> +------+-------+
# >> +----+-------+
# >> | id | name  |
# >> +----+-------+
# >> |  1 | alice |
# >> |  2 | bob   |
# >> +----+-------+
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
# >> +----+-------+
# >> | id | name  |
# >> +----+-------+
# >> |  1 | alice |
# >> |  2 | bob   |
# >> +----+-------+
