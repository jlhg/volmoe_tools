#!/usr/bin/env ruby
require "nokogiri"
require "openssl"

format = ARGV[0]
url = ARGV[1]
cookies_path = ARGV[2] || "cookies.txt"

html = `wget -O- -x --user-agent='Mozilla/5.0 (Macintosh; Intel Mac OS X 10_14_5) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/74.0.3729.169 Safari/537.36' --no-check-certificate --content-disposition --load-cookies #{cookies_path} --save-cookies #{cookies_path} '#{url}'`

case format
when "epub"
  doc = Nokogiri::HTML(html)
  doc.css("#div_cbz tr[class^='listbg']").each do |row|
    td = row.css("td")
    book1_title = td[0].css("b").text.gsub(/ +/, "")
    book1_url = td[1].css("a").select { |d| d.text == "VIP下载" }.first.attributes["href"].text
    puts [book1_title, book1_url].join("\t") if book1_title

    next if td[3].nil?

    book2_title = td[3].css("b").text.gsub(/ +/, "")
    book2_url = td[4].css("a").select { |d| d.text == "VIP下载" }.first.attributes["href"].text
    puts [book2_title, book2_url].join("\t") if book2_title
  end
end
