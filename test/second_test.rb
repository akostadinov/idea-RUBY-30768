require 'test/unit'
require "ostruct"

require 'second_test_helper'

class SecondTest < Test::Unit::TestCase
  test "simulate full network update" do
    Dir.mktmpdir do |dir|
      helper = SecondTestHelper.new
      helper.kline_files(dir, interval: OpenStruct.new, granularity: "1h", skip_lines: nil)
    end
  end
end
