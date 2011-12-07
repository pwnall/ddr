#!/usr/bin/env ruby
require 'bundler'
Bundler.setup :default, :web

require 'sinatra'

class DdrWeb < Sinatra::Application
  # Serve files in lib without any modification.
  set :public, File.join(File.dirname(__FILE__), 'public')
  
  # Serve templates from the same folder.
  set :views, File.dirname(__FILE__)
  
  helpers do
  end
  
  # Root HTML.
  get '/' do
    redirect '/game'
  end
  
  # Game HTML.
  get '/game' do
    erb :"views/game"
  end
  
  # Game JS.
  get('/application.js') do
    coffee Dir.glob('javascripts/**/*.coffee').sort.map { |f| File.read f }.join
  end
  
  # Game CSS.
  get('/application.css') { scss :"stylesheets/application" }
end
