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
# >> | 598d9d05f6453f404a7a4c74 | alice |
# >> | 598d9d06f6453f404a7a4c75 | bob   |
# >> | 598d9d06f6453f404a7a4c76 | carol |
# >> |--------------------------+-------|
# >> |------+--------------------------|
# >> | _id  | 598d9d05f6453f404a7a4c74 |
# >> | name | alice                    |
# >> |------+--------------------------|
# >> |--------------------------+-------|
# >> | _id                      | name  |
# >> |--------------------------+-------|
# >> | 598d9d05f6453f404a7a4c74 | alice |
# >> |--------------------------+-------|
