$LOAD_PATH << '../lib'
require 'tapp'
require 'org_tp'

"Hello".reverse.tapp(:tp).reverse.tapp(:tp)
# >> |-------|
# >> | olleH |
# >> |-------|
# >> |-------|
# >> | Hello |
# >> |-------|
