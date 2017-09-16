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
# >> | markdown          | false |
# >> | header            |       |
# >> | cover             | true  |
# >> | vertical          | |     |
# >> | intersection      | +     |
# >> | intersection_both | |     |
# >> | horizon           | -     |
# >> | padding           |       |
# >> | in_code           | UTF-8 |
# >> |-------------------+-------|
# >> +-------------------+-------+
# >> | markdown          | false |
# >> | header            |       |
# >> | cover             | true  |
# >> | vertical          | |     |
# >> | intersection      | +     |
# >> | intersection_both | +     |
# >> | horizon           | -     |
# >> | padding           |       |
# >> | in_code           | UTF-8 |
# >> +-------------------+-------+
