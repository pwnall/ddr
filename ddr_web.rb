#!/usr/bin/env ruby
require 'bundler'
Bundler.setup :default, :web

require 'sinatra'

class DdrWeb < Sinatra::Application
  helpers do
  end
  
  # Root HTML.
  get '/' do
    redirect '/songs'
  end
  
  # Game HTML.
  get '/game' do
    @song = {
      :id => params[:id].to_s.gsub('/', ''),  # gsub kills path manipulation.
      :steps => params[:steps].to_i,
      :style => params[:style]
    }
    erb :game
  end
  
  # Song listing HTML.
  get '/songs' do
    erb :song_list
  end
  
  # Song listing JSONP.
  get '/song_list.jsonp' do
    cb = params['callback'] || 'onJsonp'
    json = '[' + Dir['public/songs/*.ndx-json'].sort.map { |index_piece|
      File.read(index_piece)
    }.join(',') + ']'
    "#{cb}(#{json});"
  end
  
  # Song information JSONP.
  get '/song_data.jsonp' do
    cb = params['callback'] || 'onJsonp'
    # gsub kills path manipulation.
    json = File.read("public/songs/#{params[:id].gsub('/', '')}.json")
    "#{cb}(#{json});"
  end
  
  # Sheet style definition JSONP.
  get '/style_def.jsonp' do
    cb = params['callback'] || 'onJsonp'
    # gsub kills path manipulation.
    json = File.read("public/notes/defs/#{params[:id].gsub('/', '')}.json")
    "#{cb}(#{json});"
  end
  
  # Global JS.
  get('/application.js') do
    begin
      source = Dir.glob('javascripts/**/*.coffee').sort.map { |f| File.read f }.
                   join("\n")
      coffee source
    rescue
      Dir.glob('javascripts/**/*.coffee').sort.map { |f|
        puts "File: #{f}"
        CoffeeScript.compile File.read(f)
      }.join
    end
  end
  
  # Global CSS.
  get('/application.css') { scss :"../stylesheets/application" }
end
