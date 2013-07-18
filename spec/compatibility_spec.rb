# -*- coding: utf-8 -*-

require_relative "spec_helper"

describe RainTable::TableFormatter do
  it do
    header = ["ID", "名前"]
    rows = [["#1", "alice"], ["#2", "bob"]]
    RainTable::TableFormatter.format(header, rows).should == <<-EOT.strip_heredoc
+----+-------+
| ID | 名前  |
+----+-------+
| #1 | alice |
| #2 | bob   |
+----+-------+
EOT
    RainTable::TableFormatter.format(header, rows, :header => false).should == <<-EOT.strip_heredoc
+----+-------+
| #1 | alice |
| #2 | bob   |
+----+-------+
EOT
  end
end
