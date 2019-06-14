#!/usr/bin/env ruby

input_dir = ARGV[0]
output_dir = ARGV[1]

output_path = File.expand_path output_dir
Dir["#{input_dir}/**/*.kepub.epub"].each do |f|
  input_path = File.expand_path f
  output_filename = File.basename(f, ".kepub.epub") + ".cbz"
  `docker run --rm -v #{input_path}:/input.kepub.epub -v #{output_path}:/output jlhg/calibre-docker ebook-convert /input.kepub.epub '/output/#{output_filename}'`
end
