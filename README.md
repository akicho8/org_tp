# アスキーコードで表を作るライブラリ(日本語対応)

## 簡単な例

    require "rain_table"
    puts RainTable.generate([{:name => alice"}, {:name => "bob"}])
    +-------+
    | name  |
    +-------+
    | alice |
    | bob   |
    +-------+

## ラベルをつけたり幅を指定したりする例

    rows = [
      {:id => 1, :name => "alice", :description => "あいうえお"},
      {:id => 2, :name => "bob",   :description => "かきくけこ},
    ]
    puts RainTable.generate(rows){|options|
      options[:select] = [
        {:key => :id,          :label => "ID",   :size => nil},
        {:key => :name,        :label => "名前", :size => nil},
        {:key => :description, :label => "説明", :size => 6},
      ]
    }
    +----+-------+--------+
    | ID | 名前  | 説明   |
    +----+-------+--------+
    |  1 | alice | あいう |
    |  2 | bob   | かきく |
    +----+-------+--------+

## ActiveRecord で気軽にテーブル化する例

    require "rain_table"
    require "active_record"
    ActiveRecord::Base.establish_connection(:adapter => "sqlite3", :database => ":memory:")
    
    silence_stream(STDOUT) do
      ActiveRecord::Schema.define do
        suppress_messages do
          create_table :users do |t|
            t.string :name
            t.timestamps
          end
        end
      end
    end
    
    class User < ActiveRecord::Base
    end
    
    3.times{|i| User.create!(:name => i) }
    
    puts User.to_table
    +----+------+---------------------------+---------------------------+
    | id | name | created_at                | updated_at                |
    +----+------+---------------------------+---------------------------+
    |  1 |    0 | 2012-09-27 21:55:57 +0900 | 2012-09-27 21:55:57 +0900 |
    |  2 |    1 | 2012-09-27 21:55:57 +0900 | 2012-09-27 21:55:57 +0900 |
    |  3 |    2 | 2012-09-27 21:55:57 +0900 | 2012-09-27 21:55:57 +0900 |
    +----+------+---------------------------+---------------------------+
    
    puts User.order(:id).reverse_order.limit(2).to_table
    +----+------+---------------------------+---------------------------+
    | id | name | created_at                | updated_at                |
    +----+------+---------------------------+---------------------------+
    |  3 |    2 | 2012-09-27 22:39:22 +0900 | 2012-09-27 22:39:22 +0900 |
    |  2 |    1 | 2012-09-27 22:39:22 +0900 | 2012-09-27 22:39:22 +0900 |
    +----+------+---------------------------+---------------------------+
    
    puts User.first.to_table
    +----+------+---------------------------+---------------------------+
    | id | name | created_at                | updated_at                |
    +----+------+---------------------------+---------------------------+
    |  1 |    0 | 2012-09-27 21:55:57 +0900 | 2012-09-27 21:55:57 +0900 |
    +----+------+---------------------------+---------------------------+

## 過去に作っていたTableFomatterとの互換性維持用

    header = ["ID", "名前"]
    rows = [[1, "alice"], [2, "bob"]]
    puts RainTable::TableFormatter.format(header, rows)
    +----+-------+
    | ID | 名前  |
    +----+-------+
    |  1 | alice |
    |  2 | bob   |
    +----+-------+