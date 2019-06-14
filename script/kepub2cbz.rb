#!/usr/bin/env ruby
require "tempfile"
require "fileutils"

input_dir = ARGV[0]
output_dir = ARGV[1]
FileUtils.mkdir_p(output_dir)
output_path = File.expand_path output_dir
Dir["#{input_dir}/**/*.kepub.epub"].each do |f|
  filename = File.basename f
  basename = File.basename(f, ".kepub.epub") + ".cbz"
  Dir.mktmpdir do |dir|
    `cp '#{f}' #{dir}`
    `cd #{dir} && unzip '#{dir}/#{filename}'`
    `rm -f #{dir}/image/createby.png #{dir}/image/logo-mark.png`
    `zip -r -j '#{output_path}/#{basename}' #{dir}/image`
    puts "converted: #{f}"
  end
end
