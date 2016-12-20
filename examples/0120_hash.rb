$LOAD_PATH << "../lib"
require "rain_table"

puts({:id => 1, :name => "alice"}.to_t)

puts({:id => 1, :name => "alice"}.to_t(:bring_to_center => true)) # で中央に寄せたい
# >> +------+-------+
# >> | id   |     1 |
# >> | name | alice |
# >> +------+-------+
# >> +------+-------+
# >> | id   |     1 |
# >> | name | alice |
# >> +------+-------+
