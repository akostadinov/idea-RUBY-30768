class SecondGenerator
  include Enumerable

  # @param granularity [String] seconds of time interval length for each kline
  # @param interval [TimeInterval] interval to get klines for
  # @param base_kline [KlineFaker] base kline to start generating from (interval.begin_time and granularity are ignored)
  # @param skip_lines [Proc] that tests a data point whether to be skipped or not
  # @param random [Random] a PRNG for predictable results
  def initialize(granularity:, interval: nil, begin_time: nil, end_time: nil, base_kline: nil, skip_lines: nil, random: nil)
    raise(ArgumentError, "specify interval or begin_time") unless interval || begin_time

    @base_kline = base_kline
    @random = random
    @skip_lines = skip_lines
    @end_time = end_time

    @granularity = granularity
    @begin_time = begin_time || interval.begin_time
  end

  def each(&)
    enumerator = Enumerator.new(5) do |yielder|
      random ||= Random.new
      current = base_kline || KlineFaker.fake(interval: TimeInterval.new(begin_time:, length: granularity), random:)

      while end_time && current.interval.end_time < end_time
        current = current.succ
        yielder << current unless skip_lines === current.interval
      end
    end

    enumerator.each(&)
  end

  private

  attr_reader :base_kline, :begin_time, :end_time, :granularity, :random, :skip_lines
end
