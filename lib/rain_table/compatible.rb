# -*- coding: utf-8 -*-

module RainTable
  module TableFormatter
    extend self
    #
    # TableFormatter互換
    #
    #   TableFormatter の引数を、
    #
    #     header = ["ID", "名前"]
    #     rows = [["#1", "alice"], ["#2", "bob"]]
    #     TableFormatter.format(header, rows)
    #
    #     ↓
    #
    #   RainTable のインターフェイスに合わせるアダプター
    #
    #     rows = [
    #       {:_c1 => 1, :_c2 => "alice"},
    #       {:_c1 => 2, :_c2 => "bob"},
    #     ]
    #     select = [
    #       {:key => :_c1, :label => "ID",   :size => nil},
    #       {:key => :_c2, :label => "名前", :size => nil},
    #     ]
    #     RainTable.generate(rows, :select => select)
    #     +----+-------+
    #     | ID | 名前  |
    #     +----+-------+
    #     | #1 | alice |
    #     | #2 | bob   |
    #     +----+-------+
    #
    def format(header, rows, options = {})
      hashed_rows = rows.collect{|row|
        row.each_with_index.inject({}){|memo, (value, index)|
          memo.merge("_c#{index}".to_sym => value)
        }
      }
      select = header.each_with_index.collect{|label, index|
        {:key => "_c#{index}".to_sym, :label => label, :size => nil}
      }
      # hashed_rows #=> [{:_c0=>"#1", :_c1=>"alice"}, {:_c0=>"#2", :_c1=>"bob"}]
      # select      #=> [{:key=>:_c0, :size=>nil, :label=>"ID"}, {:key=>:_c1, :size=>nil, :label=>"名前"}]
      RainTable.generate(hashed_rows, {:select => select}.merge(options))
    end
  end
end

if $0 == __FILE__
  require_relative "rain_table"
  header = ["ID", "名前"]
  rows = [["#1", "alice"], ["#2", "bob"]]
  puts RainTable::TableFormatter.format(header, rows)
  puts RainTable::TableFormatter.format(header, rows, :header => false)
end
