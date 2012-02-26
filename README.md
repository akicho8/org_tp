RainTable
=========

表の生成
--------

    rows = [
      {:id => 1, :name => "alice", :description => "あいうえお"},
      {:id => 2, :name => "bob",   :description => "あいうえお"},
    ]
    puts RainTable.generate(rows){|options|
      options[:select] = [
        {:key => :id,          :label => "ID",   :size => nil},
        {:key => :name,        :label => "名前", :size => nil},
        {:key => :description, :label => "説明", :size => 6},
      ]
    )
    +----+-------+--------+
    | ID | 名前  | 説明   |
    +----+-------+--------+
    |  1 | alice | あいう |
    |  2 | bob   | あいう |
    +----+-------+--------+

TableFomatter互換
-----------------

    header = ["ID", "名前"]
    rows = [[1, "alice"], [2, "bob"]]
    puts RainTable::TableFormatter.format(header, rows)
    +----+-------+
    | ID | 名前  |
    +----+-------+
    |  1 | alice |
    |  2 | bob   |
    +----+-------+
