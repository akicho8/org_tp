# -*- coding: utf-8 -*-

require_relative "spec_helper"

describe RainTable do
  before do
    @rows = [
      {:id => 1, :name => "alice", :description => "0123456789"},
      {:id => 2, :name => "bob",   :description => "あいうえお"},
      {:id => 3, :name => "bob"},
    ]
  end

  it "空の場合" do
    RainTable.generate([]).should == ""
  end

  it "フォーマット指定なし" do
    RainTable.generate(@rows).should == <<-EOT.strip_heredoc
+----+-------+-------------+
| id | name  | description |
+----+-------+-------------+
|  1 | alice |  0123456789 |
|  2 | bob   | あいうえお  |
|  3 | bob   |             |
+----+-------+-------------+
EOT
  end

  it "ヘッダーなし" do
    RainTable.generate(@rows, :header => false).should == <<-EOT.strip_heredoc
+---+-------+------------+
| 1 | alice | 0123456789 |
| 2 | bob   | あいうえお |
| 3 | bob   |            |
+---+-------+------------+
EOT
  end

  it "パディングなし" do
    RainTable.generate(@rows, :padding => "").should == <<-EOT.strip_heredoc
+--+-----+-----------+
|id|name |description|
+--+-----+-----------+
| 1|alice| 0123456789|
| 2|bob  |あいうえお |
| 3|bob  |           |
+--+-----+-----------+
EOT
  end

  describe "組み込み" do
    it "ハッシュの配列はいままで通り" do
      [{:a => 1}].to_t.should == <<-EOT.strip_heredoc
+---+
| a |
+---+
| 1 |
+---+
EOT
    end

    it "ハッシュのみの場合は縦に表示" do
      {:a => 1}.to_t.should == <<-EOT.strip_heredoc
+---+---+
| a | 1 |
+---+---+
EOT
    end

    it "文字列の配列は縦に並べて表示" do
      ["a", "b"].to_t.should == <<-EOT.strip_heredoc
+---+
| a |
| b |
+---+
EOT
    end

    it "その他" do
      1.to_t.should be_present
      "1".to_t.should be_present
      Module.new.should be_present
      {[:a] => []}.to_t.should == <<-EOT.strip_heredoc
+------+----+
| [:a] | [] |
+------+----+
EOT
    end

    it "ハッシュの配列で値が配列のとき幅がおかしくならない" do
      RainTable.generate([{"a" => ["a"]}]).should == <<-EOT.strip_heredoc
+-------+
| a     |
+-------+
| ["a"] |
+-------+
EOT
    end
  end
end
