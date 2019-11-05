#!/usr/bin/env ruby
require "fileutils"
require "shellwords"
require "tempfile"

require "concurrent"

input_dir = ARGV[0]
output_dir = ARGV[1]
FileUtils.mkdir_p(output_dir)
output_path = File.expand_path output_dir
pool = Concurrent::FixedThreadPool.new(8)
Dir["#{input_dir}/**/*.kepub.epub"].each do |file_path|
  f = Shellwords.escape(file_path)
  pool.post do
    filename = File.basename(f)
    basename = File.basename(f, ".kepub.epub") + ".cbz"
    Dir.mktmpdir do |dir|
      `cp #{f} #{dir}`
      `cd #{dir} && unzip #{dir}/#{filename}`
      `rm -f #{dir}/image/createby.png #{dir}/image/logo-mark.png`
      `zip -r -j #{output_path}/#{basename} #{dir}/image`
      puts "converted: #{file_path}"
    end
  end
end
pool.shutdown
pool.wait_for_termination
