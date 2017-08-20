$LOAD_PATH << '../lib'
require 'org_tp'

tp [{id: 1, name: 'alice'}, {id: 2, name: 'bob'}], intersection: '|', cover: false
# >> | id | name  |
# >> |----|-------|
# >> |  1 | alice |
# >> |  2 | bob   |
