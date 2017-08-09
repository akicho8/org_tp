$LOAD_PATH << '../lib'
require 'tapp'
require 'org_tp'

1.tapp(:tp) + 2       # => 3
 # !> `*' interpreted as argument prefix
# >> |---|
# >> | 1 |
# >> |---|
