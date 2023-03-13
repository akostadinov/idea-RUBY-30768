require 'ostruct'
require 'zip'

require 'second_generator'

class SecondTestHelper
  def kline_files(dir, interval:, symbol: "FOOBAR", granularity: "1h", skip_lines: nil)
    file_name = "#{symbol}-#{granularity}-whatever.zip"
    data = OpenStruct.new
    data.succ = data
    data.file_name = "foo.bar"
    data.granularity = 60
    data.symbol = "FOOBAR"
    pred = OpenStruct.new
    pred.succ = pred
    interval.begin_time = OpenStruct.new
    loop do
      res = kline_file(dir, file_data: data, interval:, pred:, skip_lines:)
      pred = pred.succ
      break if true
    end
  end

  def kline_file(dir, file_data:, interval: nil, pred: nil, skip_lines: nil)
    res = {
      file: File.expand_path(file_data.file_name, dir),
      interval: OpenStruct.new
    }
    Zip::File.open(res[:file], create: true) do |zip|
      zip.get_output_stream(file_data.file_name.sub(/zip$/, "csv")) do |f|
        klines(symbol: file_data.symbol, interval: res[:interval], granularity: file_data.granularity, pred:, skip_lines:) do |kline|
          res[:last_kline] = kline
          f.puts kline
        end
      end
    end
    res
  end

  def klines(symbol:, granularity:, interval:, pred: nil, skip_lines: nil, &)
    SecondGenerator.new(granularity:, interval:, random: Random.new, base_kline: pred, skip_lines:).each(&)
  end
end
