#!/usr/bin/env ruby1.9.1

require 'rubygems'
require 'digest/md5'
require 'json'
require 'zip/zip'

# Unpacks a song.
class SmSong
  # Empty data structures.
  def initialize
    @fs_data = {}
    
    @metadata = {}
    @sheets = []
    @media = {}
    
    @breaks = []
    
    @bpms = []
  end
  
  # Extracts the data from a .smzip file.
  def parse_smzip(path)
    unpack_smzip path
    @fs_data.each do |name, contents|
      if /\.sm$/ =~ name
        parse_sm contents, File.dirname(name)
      end
    end
  end
  
  # Hash that obeys the JSON format restriction.
  def as_json
    {
      :metadata => @metadata,
      :sheets => @sheets.each { |sheet|
        {}
      },
      :sync => {
        :bpms => @bpms.sort,
        :breaks => @breaks.sort 
      },
      
    }
  end
  
  def json_path
    "songs/#{basename}.json"
  end
  
  def music_path
    "songs/#{basename}.#{music_format}"
  end
  
  def music_format
    @media[:music_file].split('.').last
  end
  
  def basename
    Digest::MD5.hexdigest @metadata[:title]
  end

  # Parses the data in a .sm file.
  def parse_sm(data, path)
    # Windows newlines.
    data = data.gsub("\r\n", "\n")
    # Remove comments.
    data.gsub!(/\/\/.*$/, '')
    
    data.scan(/(^|\n)\w*#([^:]+)\:(.*?)\;(\n|$)/m) do |_, name, section, _|
      name.strip!
      section.strip!
      case name.downcase
      when 'title'
        @metadata[:title] = section
      when 'subtitle'
        @metadata[:subtitle] = section
      when 'artist'
        @metadata[:artist] = section
      when 'credit'
        @metadata[:credit] = section
      
      when 'music'
        @media[:music] = File.join(path, section)

      when 'offset'
        @breaks << [0, section.to_f]
      when 'stops'
        @stops << section.split(',').map do |directive|
          directive.split('=').map(&:strip).map(&:to_f)
        end
        
      when 'bpms'
        @bpms << section.split(',').map do |directive|
          directive.split('=').map(&:strip).map(&:to_f)
        end
        
      when 'notes'
        
      end
    end
  end
   
  # Unpacks a .zip file into the @fs_data internal structure. 
  def unpack_smzip(path)
    Zip::ZipFile.open(path) do |zip|
      zip.each do |entry|
        next unless entry.file?
        @fs_data[entry.name] = entry.get_input_stream { |io| io.read }
      end
    end
  end
end

if ARGV.length != 1
  print "Usage: #{$0} input.smzip\n"
  exit 1
end

# Parse input.
song = SmSong.new
song.parse_smzip File.expand_path(ARGV[0])

# Create json file.
FileUtils.mkpath File.join('public', File.dirname(song.json_path))
File.open(File.join('public', song.json_path), 'w') do |f|
  JSON.dump f, song.as_json
end

# Create music file.
