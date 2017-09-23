require_relative 'spec_helper'

describe OrgTp do
  require 'tempfile'
  require 'active_support/testing/stream'
  include ActiveSupport::Testing::Stream

  it do
    capture(:stdout) { tp 1 }.should == <<~EOT
|---|
| 1 |
|---|
    EOT
  end

  it 'result is like p method' do
    v = Object.new
    quietly { pt v }.should == v
  end
end
