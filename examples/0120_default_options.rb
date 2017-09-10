$LOAD_PATH << '../lib'
require 'org_tp'

tp 1, intersection_both: '+'

tp OrgTp.default_options
OrgTp.default_options.update(intersection_both: '+')
tp OrgTp.default_options

# >> +---+
# >> | 1 |
# >> +---+
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
