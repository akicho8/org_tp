$LOAD_PATH << "../lib"
require "org_tp"

tp OrgTp::Generator.default_options
OrgTp::Generator.default_options.update(intersection_both: "+")
tp OrgTp::Generator.default_options
# >> |-------------------+-------|
# >> | header            |       |
# >> | vertical          | |     |
# >> | intersection      | +     |
# >> | intersection_both | |     |
# >> | horizon           | -     |
# >> | padding           |       |
# >> | in_code           | UTF-8 |
# >> |-------------------+-------|
# >> +-------------------+-------+
# >> | header            |       |
# >> | vertical          | |     |
# >> | intersection      | +     |
# >> | intersection_both | +     |
# >> | horizon           | -     |
# >> | padding           |       |
# >> | in_code           | UTF-8 |
# >> +-------------------+-------+
