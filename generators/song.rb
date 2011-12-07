#!/usr/bin/env ruby

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
  
  # Hash that obeys the JSON format restrictions.
  def as_json
    {
      :metadata => @metadata,
      :sheets => @sheets,
      :sync => {
        :bpms => @bpms,
        :breaks => @breaks 
      },
      :music => music_path
    }
  end
  
  # The song's index entry, as a hash that obeys the JSON format restrictions.
  def index_entry_as_json
    {
      :json => json_path,
      :music => music_path,
      :metadata => @metadata,
      :sync => {
        :bpms => @bpms,
        :breaks => @breaks 
      },
      :sheets => @sheets.map { |sheet| sheet[:metadata] }
    }
  end

  # Path to the song's JSON file, relative to public/
  def json_path
    "songs/#{basename}.json"
  end
  
  # Path to the song's JSON file, relative to public/
  def music_path
    "songs/#{basename}.#{music_format}"
  end

  # Path to the song's entry file in the big index, relative to public/
  def index_entry_path
    "songs/#{basename}.ndx-json"
  end
  
  # Extension of the song's music file (most likely mp3).
  def music_format
    @media[:music].split('.').last.downcase
  end

  # Contents of the music file.  
  def music_data
    @fs_data[@media[:music_file]]
  end
  
  # Root used by all the song's files.
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
      when 'samplestart'
        @metadata[:sample_start] = section.to_f
      when 'samplestart'
        @metadata[:sample_length] = section.to_f
        
      when 'music'
        @media[:music] = File.join(path, section)

      when 'offset'
        @breaks << { :beat => 0, :seconds => section.to_f }
      when 'stops'
        @breaks << section.split(',').map do |pair|
          beat, seconds = *pair.split('=').map(&:strip).map(&:to_f)
          { :beat => beat, :seconds => seconds }
        end
      when 'bpms'
        @bpms += section.split(',').map do |pair|
          beat, bpm = *pair.split('=').map(&:strip).map(&:to_f)
          { :beat => beat, :bpm => bpm }
        end
        
      when 'notes'
        # Metadata.
        type_text, desc, dclass, dmeter, radar, table_text =
            *section.split(':').map(&:strip)
        sheet_type = type_text.gsub('-', '_').to_sym
        radar_data = *radar.split(',').map(&:to_f)
        sheet = { :metadata => {
          :type => sheet_type,
          :description => desc,
          :difficulty => {
            :class => dclass,
            :steps => dmeter.to_f,
            :radar => {
              :voltage => radar_data[0],
              :stream => radar_data[1],
              :chaos => radar_data[2],
              :freeze => radar_data[3],
              :air => radar_data[4]
            }
          } 
        }}
        
        # Note sequence.
        table = table_text.split(",").map do |measure|
          measure.strip.split(/\s+/).map do |row|
            row.each_char.to_a
          end
        end
        hold_starts = {}
        notes = []
        table.each_with_index do |measure_data, measure|
          measure_data.each_with_index do |row_data, row|
            beat = measure * 4 + (row * 4 / measure_data.length.to_f)
            row_data.each_with_index do |note_type, note_index|
              case note_type
              when '0'
                # Nothing.
              when '1'
                # Tap.
                note = { :index => note_index, :type => :tap,
                         :start_beat => beat }
                notes << note
              when '2'
                # Start hold.
                hold_starts[note_index] = beat
              when '3'
                # End hold.
                note = { :index => note_index, :type => :hold,
                         :start_beat => hold_starts[note_index],
                         :end_beat => beat }
                notes << note
              when '4'
                # Roll.
                raise 'Rolls not yet implemented'
              when 'M'
                # Mine.
                note = { :index => note_index, :type => :mine,
                         :start_beat => beat }
                notes << note
              when 'L'
                raise 'Lifts not yet implemented'
              else
                # Special tap.
                note = { :index => note_index, :type => :tap,
                         :start_beat => beat, :tap_note => note_type }
                notes << note
              end
            end
          end
        end
        
        # Note coalescing.
        notes.sort_by! do |note|
          [note[:start_beat], note[:end_beat] || note[:start_beat],
           note[:index]]
        end
        
        # Note naming.
        notes.each do |note|
          note[:name] = note_name sheet_type, note[:index]
          note.delete :index
        end

        sheet[:notes] = notes
        @sheets << sheet
      end
    end
  end
  
  # Converts note indexes (positions on the .sm sheet) to "names" (codes).
  def note_name(sheet_type, note_index)
    %w(l d u r)[note_index]
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

# Create JSON data file.
FileUtils.mkpath File.join('public', File.dirname(song.json_path))
File.open(File.join('public', song.json_path), 'w') do |f|
  JSON.dump song.as_json, f
end

# Create music file.
FileUtils.mkpath File.join('public', File.dirname(song.music_path))
File.open(File.join('public', song.music_path), 'wb') do |f|
  f.write song.music_data
end

# Create JSON index entry file.
FileUtils.mkpath File.join('public', File.dirname(song.index_entry_path))
File.open(File.join('public', song.index_entry_path), 'w') do |f|
  JSON.dump song.index_entry_as_json, f
end
