$LOAD_PATH << '../lib'
require 'active_record'
require 'mongoid'
require 'org_tp'

Mongo::Logger.logger.level = Logger::INFO
Mongoid::Config.connect_to('test')
Mongoid::Clients.default.database.drop

class User
  include Mongoid::Document
  field :name, type: String
end

['alice', 'bob', 'carol'].each { |e| User.create!(name: e) }

tp User
tp User.first
tp User.limit(1)
# >> |--------------------------+-------|
# >> | _id                      | name  |
# >> |--------------------------+-------|
# >> | 59ed43e9f6453f17bc8e4fd3 | alice |
# >> | 59ed43e9f6453f17bc8e4fd4 | bob   |
# >> | 59ed43e9f6453f17bc8e4fd5 | carol |
# >> |--------------------------+-------|
# >> |------+--------------------------|
# >> |  _id | 59ed43e9f6453f17bc8e4fd3 |
# >> | name | alice                    |
# >> |------+--------------------------|
# >> |--------------------------+-------|
# >> | _id                      | name  |
# >> |--------------------------+-------|
# >> | 59ed43e9f6453f17bc8e4fd3 | alice |
# >> |--------------------------+-------|
