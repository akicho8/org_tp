# -*- coding: utf-8 -*-
$LOAD_PATH << "../lib"
require "rain_table"

puts [{"a" => ["a"]}].to_t
puts [{"a" => {"a" => 1}}].to_t
# >> +-------+
# >> | a     |
# >> +-------+
# >> | ["a"] |
# >> +-------+
# >> +----------+
# >> | a        |
# >> +----------+
# >> | {"a"=>1} |
# >> +----------+
