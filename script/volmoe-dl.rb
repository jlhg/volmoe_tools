#!/usr/bin/env ruby
require "csv"
require "fileutils"
require "concurrent"

url_path = ARGV[0]
output_dir = ARGV[1] || "output"
cookies_path = ARGV[2] || "cookies.txt"

FileUtils.mkdir_p(output_dir)
pool = Concurrent::FixedThreadPool.new(5)
CSV.foreach(url_path, col_sep: "\t", headers: false) do |row|
  url = row[1]
  pool.post do
    `wget -x --user-agent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36' --no-check-certificate --content-disposition --load-cookies #{cookies_path} -P #{output_dir} '#{url}'`
  end
end
pool.shutdown
pool.wait_for_termination
