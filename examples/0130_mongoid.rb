$LOAD_PATH << '../lib'
require 'active_record'
require 'mongoid' # !> method redefined; discarding old as_json
require 'org_tp'

Mongo::Logger.logger.level = Logger::INFO
Mongoid::Config.connect_to('test')
Mongoid::Clients.default.database.drop

class User
  include Mongoid::Document
  field :name, type: String
end

['alice', 'bob', 'carol'].each { |e| User.create!(name: e) } # !> method redefined; discarding old text_search

tp User
tp User.first
tp User.limit(1)
# >> |--------------------------+-------|
# >> | _id                      | name  |
# >> |--------------------------+-------|
# >> | 59bb8090f6453f365f93ddc3 | alice |
# >> | 59bb8090f6453f365f93ddc4 | bob   |
# >> | 59bb8090f6453f365f93ddc5 | carol |
# >> |--------------------------+-------|
# >> |------+--------------------------|
# >> | _id  | 59bb8090f6453f365f93ddc3 |
# >> | name | alice                    |
# >> |------+--------------------------|
# >> |--------------------------+-------|
# >> | _id                      | name  |
# >> |--------------------------+-------|
# >> | 59bb8090f6453f365f93ddc3 | alice |
# >> |--------------------------+-------|
