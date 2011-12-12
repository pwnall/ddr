#!/usr/bin/env ruby

# Usage:
#   bundle exec generators/notes.rb

require 'rubygems'
require 'json'
require 'nokogiri'

# The definition of a StepMania song style, such as dance_single.
class StyleDef
  def initialize(json_data, input_path)
    @data = json_data
    @data['id'] = File.basename(input_path).split('.', 2).first
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
    
    # Convert the root symbol from <svg> to <symbol>.
    root.name = 'symbol'
    root['id'] = image_id

    # Strip all attributes except for viewBox.
    raise "#{image_id} does not have a viewBox" unless root['viewBox']
    (root.attributes.keys - ['viewBox']).each do |name|
      root.remove_attribute name
    end
    
    # Set width and height to "100%".
    root['width'] = '100%'
    root['height'] = '100%'
    
    # Remove xmlns= from the XML.
    xml = root.to_xml
    xml.sub!(/^\<symbol xmlns="http:\/\/www.w3.org\/2000\/svg"/, '<symbol')
    xml
  end
end

Dir['public/notes/defs/*.raw.json'].each do |source|
  style_def = StyleDef.new JSON.parse(File.read(source)), source
  style_def.embed_images 'public/notes'

  target = source.sub /\.raw\.json$/, '.json'
  File.open(target, 'w') { |f| JSON.dump style_def.as_json, f }
end
