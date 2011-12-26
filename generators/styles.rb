#!/usr/bin/env ruby

# Usage:
#   bundle exec generators/styles.rb

require 'rubygems'
require 'json'
require 'nokogiri'

# The definition of a StepMania song style, such as dance_single.
class StyleDef
  def initialize(json_data, input_path)
    @data = json_data
    @data['id'] = File.basename(input_path).split('.', 2).first
    
    # Switch from 1-based indexing to 0-based indexing.
    @data['notes'] = @data['notes'].map do |note|
      note = note.dup
      note['player'] -= 1
      note['position'] -= 1
      note
    end
  end
  
  # Inlines the bodies of the SVG note images into the style definition.
  def embed_images(image_path)
    @data['images'] ||= {}
    images = @data['notes'].map { |note| note['image'] }.uniq.sort
    images.each do |image|
      svg = Nokogiri::XML File.read(File.join(image_path, image + '.svg'))
      @data['images'][image] = process_note_svg svg, image
    end
  end
  
  # Hash that obeys the JSON format restrictions.
  def as_json
    @data
  end
  
  # Processes a note's SVG image into a format that's easy to embed.
  def process_note_svg(svg, image_id)
    root = svg.root
    raise "#{image_id} is not an SVG image" unless root.name == 'svg'
    
    # Strip all attributes except for viewBox.
    raise "#{image_id} does not have a viewBox" unless root['viewBox']
    sizes = root['viewBox'].strip.split.map(&:to_f)
    raise "#{image_id} has a poorly formatted viewBox" unless sizes.length == 4
    unless sizes[0] == 0 && sizes[1] == 0
      raise "#{image_id} has a viewBox that doesn't start at 0 0"
    end

    {
      :width => sizes[2], :height => sizes[3],
      :svg => root.inner_html.strip
    }
  end
end

Dir['public/styles/defs/*.raw.json'].each do |source|
  style_def = StyleDef.new JSON.parse(File.read(source)), source
  style_def.embed_images 'public/styles/notes'

  target = source.sub /\.raw\.json$/, '.json'
  File.open(target, 'w') { |f| JSON.dump style_def.as_json, f }
end
