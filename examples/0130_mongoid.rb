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
# >> | 5988562bf6453fd586c8a492 | alice |
# >> | 5988562cf6453fd586c8a493 | bob   |
# >> | 5988562cf6453fd586c8a494 | carol |
# >> |--------------------------+-------|
# >> |------+--------------------------|
# >> | _id  | 5988562bf6453fd586c8a492 |
# >> | name | alice                    |
# >> |------+--------------------------|
# >> |--------------------------+-------|
# >> | _id                      | name  |
# >> |--------------------------+-------|
# >> | 5988562bf6453fd586c8a492 | alice |
# >> |--------------------------+-------|
