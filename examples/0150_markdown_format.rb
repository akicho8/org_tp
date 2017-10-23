$LOAD_PATH << '../lib'
require 'org_tp'

array = [
  {id: 1, name: 'alice' },
  {id: 2, name: 'bob'   },
]

# tp with options
tp array, intersection: '|', cover: false

# to_t with options
array.to_t(intersection: '|', cover: false) # => "| id | name  |\n|----|-------|\n|  1 | alice |\n|  2 | bob   |\n"

puts

# set global options
OrgTp.default_options.update(intersection: '|', cover: false)
tp array

######################################## markdown option

# tp with options
tp array, markdown: true

# to_t with options
array.to_t(markdown: true) # => "| id | name  |\n|----|-------|\n|  1 | alice |\n|  2 | bob   |\n"

puts

# set global options
OrgTp.default_options.update(markdown: true)
tp array
# >> | id | name  |
# >> |----|-------|
# >> |  1 | alice |
# >> |  2 | bob   |
# >> 
# >> | id | name  |
# >> |----|-------|
# >> |  1 | alice |
# >> |  2 | bob   |
# >> | id | name  |
# >> |----|-------|
# >> |  1 | alice |
# >> |  2 | bob   |
# >> 
# >> | id | name  |
# >> |----|-------|
# >> |  1 | alice |
# >> |  2 | bob   |
