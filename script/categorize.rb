#!/usr/bin/env ruby
require "fileutils"

input_dir = ARGV[0]
Dir["#{input_dir}/*"].each do |f|
  m = f.match(/\[.+\]\[(.+)\].+/)
  abort("Failed to parse path: #{f}") if m.nil?
  output_dir = File.join(input_dir, m[1])
  FileUtils.mkdir_p(output_dir)
  FileUtils.mv f, output_dir
end
