require_relative "spec_helper"

describe OrgTp do
  before do
    @rows = [
      {id: 1, name: "alice", description: "0123456789"},
      {id: 2, name: "bob",   description: "あいうえお"},
      {id: 3, name: "bob"},
    ]
  end

  it "空の場合" do
    OrgTp.generate([]).should == ""
  end

  it "フォーマット指定なし" do
    OrgTp.generate(@rows).should == <<~EOT
|----+-------+-------------|
| id | name  | description |
|----+-------+-------------|
|  1 | alice |  0123456789 |
|  2 | bob   | あいうえお  |
|  3 | bob   |             |
|----+-------+-------------|
EOT
  end

  it "ヘッダーなし" do
    OrgTp.generate(@rows, header: false).should == <<~EOT
|---+-------+------------|
| 1 | alice | 0123456789 |
| 2 | bob   | あいうえお |
| 3 | bob   |            |
|---+-------+------------|
EOT
  end

  it "パディングなし" do
    OrgTp.generate(@rows, padding: "").should == <<~EOT
|--+-----+-----------|
|id|name |description|
|--+-----+-----------|
| 1|alice| 0123456789|
| 2|bob  |あいうえお |
| 3|bob  |           |
|--+-----+-----------|
EOT
  end

  describe "組み込み" do
    it "ハッシュの配列はいままで通り" do
      [{a: 1}].to_t.should == <<~EOT
|---|
| a |
|---|
| 1 |
|---|
EOT
    end

    it "ハッシュのみの場合は縦に表示" do
      {a: 1}.to_t.should == <<~EOT
|---+---|
| a | 1 |
|---+---|
EOT
    end

    it "文字列の配列は縦に並べて表示" do
      ["a", "b"].to_t.should == <<~EOT
|---|
| a |
| b |
|---|
EOT
    end

    it "その他" do
      1.to_t.should be_present
      "1".to_t.should be_present
      Module.new.should be_present
      {[:a] => []}.to_t.should == <<~EOT
|------+----|
| [:a] | [] |
|------+----|
EOT
    end

    it "ハッシュの配列で値が配列のとき幅がおかしくならない" do
      OrgTp.generate([{"a" => ["a"]}]).should == <<~EOT
|-------|
| a     |
|-------|
| ["a"] |
|-------|
EOT
    end
  end
end
