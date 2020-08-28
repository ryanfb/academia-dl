#!/usr/bin/env ruby

require 'nokogiri'
require 'uri'
require 'open-uri'
require 'open_uri_redirections'
require 'addressable/uri'

REFERER = 'http://scholar.google.com'
PREFIX = 'https://www.academia.edu/download'
OPEN_URI_OPTIONS = {"Referer" => REFERER, :allow_redirections => :all}
MAX_RETRIES = 5

ARGV.each do |academia_url|
  uri = Addressable::URI.parse(academia_url).normalize.to_s
  if URI(uri).host.nil? || URI(uri).path.nil? || URI(uri).path.empty? || !%{http https}.include?(URI(uri).scheme)
    $stderr.puts "Error parsing URL: #{academia_url}"
    exit 1
  end
  filename = "#{URI(uri).path.split('/').last[0..250]}.pdf"
  doc = nil
  if File.exist?(filename)
    $stderr.puts "#{filename} already exists, skipping"
  else
    if URI(uri).host.split('.')[-2..-1].join('.') != 'academia.edu'
      $stderr.puts "URL host must be 'academia.edu', error with URL: #{academia_url}"
      exit 1
    end
    retries = 0
    begin
      doc = Nokogiri::HTML(URI.open(uri))
    rescue OpenURI::HTTPError => e
      $stderr.puts e.inspect
      retries += 1
      if retries < MAX_RETRIES
        sleep(5)
        retry
      else
        $stderr.puts "Max retries (= #{MAX_RETRIES}) reached, exiting after trying to open URL: #{academia_url}"
        exit 1
      end
    end
    begin
      download_url = doc.css('a.js-swp-download-button').first['href']
      download_id = download_url.split('/')[-2]
      url = "#{PREFIX}/#{download_id}/#{filename}"
      $stderr.puts "Resolved download URL: #{url}"
      IO.copy_stream(open(url, OPEN_URI_OPTIONS), filename)
      $stderr.puts "Downloaded #{filename}"
    rescue StandardError => e
      $stderr.puts "Error parsing/downloading file for URL #{url}: #{e.inspect}"
      exit 1
    end
  end
end
