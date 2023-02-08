require 'test/unit'
require "lunar_phase"

class LunarPhaseTest < Test::Unit::TestCase
  setup do
    @some_time = Time.new(2023, 1, 4, 1, 57, 13, 0)
    @some_old_time = Time.new(1980, 3, 5, 12, 0, 0, 0)

    @full_time = Time.new(2023, 1, 6, 23, 5, 11, 0)
    @full_time_mooninfo_org = Time.new(2023, 1, 6, 23, 9, 0, 0)
  end

  test "lunar age" do
    assert_equal 12.13, LunarPhase.age(@some_time).floor(2)
    assert_equal 18.76, LunarPhase.age(@some_old_time).floor(2)
  end

  test "lunar illumination" do
    assert_equal 92.6, (LunarPhase.illumination(@some_time) * 100).floor(2)
  end

  test "full" do
    assert LunarPhase.full?(@full_time_mooninfo_org)
  end
end
