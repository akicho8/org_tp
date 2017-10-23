$LOAD_PATH << '../lib'
require 'active_record'
require 'org_tp'

ActiveRecord::Base.establish_connection(adapter: 'sqlite3', database: ':memory:')
ActiveRecord::Migration.verbose = false
ActiveRecord::Schema.define do
  create_table :users do |t|
    t.string :name
  end
end

class User < ActiveRecord::Base
end

['alice', 'bob', 'carol'].each { |e| User.create!(name: e) }

tp User
tp User.first
tp User.limit(1)
tp ActiveRecord::Base.connection.select_all('SELECT * FROM users')
tp ActiveRecord::Base.connection.select_one('SELECT * FROM users')
tp ActiveRecord::Base.connection.select_value('SELECT 1 + 2')
# >> |----+-------|
# >> | id | name  |
# >> |----+-------|
# >> |  1 | alice |
# >> |  2 | bob   |
# >> |  3 | carol |
# >> |----+-------|
# >> |------+-------|
# >> |   id | 1     |
# >> | name | alice |
# >> |------+-------|
# >> |----+-------|
# >> | id | name  |
# >> |----+-------|
# >> |  1 | alice |
# >> |----+-------|
# >> |----+-------|
# >> | id | name  |
# >> |----+-------|
# >> |  1 | alice |
# >> |  2 | bob   |
# >> |  3 | carol |
# >> |----+-------|
# >> |------+-------|
# >> |   id | 1     |
# >> | name | alice |
# >> |------+-------|
# >> |---|
# >> | 3 |
# >> |---|
