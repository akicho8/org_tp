# -*- coding: utf-8 -*-

require_relative "spec_helper"

describe RainTable do
  before do
    @rows = [
      {:id => 1, :name => "alice", :description => "0123456789"},
      {:id => 2, :name => "bob",   :description => "あいうえお"},
      {:id => 3, :name => "bob",   :description => "あいう"},
    ]
    @select = [
      {:key => :id,          :label => "ID",   :size => nil},
      {:key => :name,        :label => "名前", :size => nil, :align => :right},
      {:key => :description, :label => "説明", :size => 8, :align => :right},
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
|  3 | bob   | あいう      |
+----+-------+-------------+
EOT
  end

  it "オプションをブロックで指定" do
    RainTable.generate(@rows){|options|
      options[:select] = @select
    }.should == <<-EOT.strip_heredoc
+----+-------+----------+
| ID |  名前 |     説明 |
+----+-------+----------+
|  1 | alice | 01234567 |
|  2 |   bob | あいうえ |
|  3 |   bob |   あいう |
+----+-------+----------+
EOT
  end

  it "ID昇順" do
    RainTable.generate(@rows, :select => @select, :sort_by => :id).should == <<-EOT.strip_heredoc
+----+-------+----------+
| ID |  名前 |     説明 |
+----+-------+----------+
|  1 | alice | 01234567 |
|  2 |   bob | あいうえ |
|  3 |   bob |   あいう |
+----+-------+----------+
EOT
  end

  it "ID降順" do
    RainTable.generate(@rows, :select => @select, :sort_by => proc{|row|-row[:id]}).should == <<-EOT.strip_heredoc
+----+-------+----------+
| ID |  名前 |     説明 |
+----+-------+----------+
|  3 |   bob |   あいう |
|  2 |   bob | あいうえ |
|  1 | alice | 01234567 |
+----+-------+----------+
EOT
  end

  it "ヘッダーなし" do
    RainTable.generate(@rows, :select => @select, :header => false).should == <<-EOT.strip_heredoc
+---+-------+----------+
| 1 | alice | 01234567 |
| 2 |   bob | あいうえ |
| 3 |   bob |   あいう |
+---+-------+----------+
EOT
  end

  it "パディングなし" do
      RainTable.generate(@rows, :select => @select, :padding => false).should == <<-EOT.strip_heredoc
+--+-----+--------+
|ID| 名前|    説明|
+--+-----+--------+
| 1|alice|01234567|
| 2|  bob|あいうえ|
| 3|  bob|  あいう|
+--+-----+--------+
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

    it "その他" do
      1.to_t.should be_present
      "1".to_t.should be_present
      Module.new.should be_present
    end
  end
end
