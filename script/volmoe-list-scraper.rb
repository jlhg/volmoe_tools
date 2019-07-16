#!/usr/bin/env ruby
require "set"
require "nokogiri"
require 'pry'

url = ARGV[0]
html = `wget -O- -x --no-check-certificate --content-disposition '#{url}'`
data = Set.new
doc = Nokogiri::HTML(html)
doc.css("a[href^='https://vol.moe/comic/']").each do |row|
  data.add row.attribute("href").value
end

puts data.to_a.join("\n")
