#!/usr/bin/env ruby

require 'nokogiri'
require 'uri'
require 'open-uri'
require 'open_uri_redirections'

REFERER = 'http://scholar.google.com'
PREFIX = 'https://www.academia.edu/download'
OPEN_URI_OPTIONS = {"Referer" => REFERER, :allow_redirections => :all}

ARGV.each do |academia_url|
  doc = nil
  begin
    doc = Nokogiri::HTML(open(academia_url))
  rescue OpenURI::HTTPError => e
    $stderr.puts e.inspect
    sleep(5)
    retry
  end
  download_url = doc.css('a.js-swp-download-button').first['href']
  download_id = download_url.split('/')[-2]
  filename = "#{URI(academia_url).path.split('/').last}.pdf"
  url = "#{PREFIX}/#{download_id}/#{filename}"
  if File.exist?(filename)
    $stderr.puts "#{filename} already exists, skipping"
  else
    IO.copy_stream(open(url, OPEN_URI_OPTIONS), filename)
    $stderr.puts "Downloaded #{filename}"
  end
end
