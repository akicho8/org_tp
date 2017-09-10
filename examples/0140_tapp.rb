$LOAD_PATH << '../lib'
require 'tapp'
require 'org_tp'

"Hello".reverse.tapp.reverse.tapp
# >> |-------|
# >> | olleH |
# >> |-------|
# >> |-------|
# >> | Hello |
# >> |-------|
