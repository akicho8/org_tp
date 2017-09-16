require_relative 'spec_helper'

describe OrgTp do
  before do
    @rows = [
      {id: 1, name: 'alice', description: '0123456789'},
      {id: 2, name: 'bob',   description: 'あいうえお'},
      {id: 3, name: 'bob'},
    ]
  end

  it 'empty array' do
    OrgTp.generate([]).should == ''
  end

  it 'default' do
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

  it 'header: false' do
    OrgTp.generate(@rows, header: false).should == <<~EOT
|---+-------+------------|
| 1 | alice | 0123456789 |
| 2 | bob   | あいうえお |
| 3 | bob   |            |
|---+-------+------------|
EOT
  end

  it 'padding disable' do
    OrgTp.generate(@rows, padding: '').should == <<~EOT
|--+-----+-----------|
|id|name |description|
|--+-----+-----------|
| 1|alice| 0123456789|
| 2|bob  |あいうえお |
| 3|bob  |           |
|--+-----+-----------|
EOT
  end

  it 'markdown format' do
    OrgTp.generate(@rows, intersection: '|', cover: false).should == <<~EOT
| id | name  | description |
|----|-------|-------------|
|  1 | alice |  0123456789 |
|  2 | bob   | あいうえお  |
|  3 | bob   |             |
EOT

    OrgTp.generate(@rows, markdown: true).should == <<~EOT
| id | name  | description |
|----|-------|-------------|
|  1 | alice |  0123456789 |
|  2 | bob   | あいうえお  |
|  3 | bob   |             |
EOT
  end

  describe 'various to_t' do
    it 'hash array' do
      [{a: 1}].to_t.should == <<~EOT
|---|
| a |
|---|
| 1 |
|---|
EOT
    end

    it 'Hash' do
      {a: 1}.to_t.should == <<~EOT
|---+---|
| a | 1 |
|---+---|
EOT
    end

    it 'String Array' do
      ['a', 'b'].to_t.should == <<~EOT
|---|
| a |
| b |
|---|
EOT
    end

    it 'Others' do
      1.to_t.should be_present
      '1'.to_t.should be_present
      Module.new.should be_present
      {[:a] => []}.to_t.should == <<~EOT
|------+----|
| [:a] | [] |
|------+----|
EOT
    end

    it 'Array of hashes and width is correct even when value is array' do
      OrgTp.generate([{'a' => ['a']}]).should == <<~EOT
|-------|
| a     |
|-------|
| ["a"] |
|-------|
EOT
    end

    it 'Array containing Hash and others' do
      OrgTp.generate([["a", "b"], {"c" => "d"}]).should == <<~EOT
|-----------------+---|
| (array_element) | c |
|-----------------+---|
| ["a", "b"]      |   |
|                 | d |
|-----------------+---|
EOT
    end
  end
end
