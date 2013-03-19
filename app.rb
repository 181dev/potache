# -*- coding: utf-8 -*-

require 'sinatra/base'
require 'sinatra/mustache'
require 'mongo'
#require "sinatra/reloader"
require 'yaml'
require 'json'

# Self editing application framework
# POTACHE
# MIT
class App < Sinatra::Base
  COLL_SYSTEM = 'POTACHE_SYSTEM'
  config = YAML::load(File.open('config.yml'))

  configure :development do
    #register Sinatra::Reloader
  end

  configure :production do
  end

  get '/' do
    @colls = []
    Mongo::Connection.new(config["mongo_host"]).db(config["mongo_db"]).collections.each{|x|
      if x.name != 'system.indexes' then
        @colls << x.name
      end
    }
    mustache :index
  end

  get '/edit/:name' do
    @name = params[:name]
    @body = ""
    if FileTest.exist?("./views/" + @name + ".mustache") then
      @body = File.read("./views/" + @name + ".mustache")
    else
      @body = File.read("./views/template.mustache")
    end
    mustache :edit
  end

  post '/edit' do
    @name = params[:name] + ".mustache"
    @body = params[:body]
    File.write("./views/" + @name , @body)
    "Success"
  end

  get '/:name' do
    content_type :html, 'charset' => 'utf-8'
    @name = params[:name]
    if FileTest.exist?("./views/" + @name + ".mustache") then
      db = Mongo::Connection.new(config["mongo_host"]).db(config["mongo_db"])
      @items = db[@name].find.sort([:_id, :desc]).to_a
      mustache @name.to_sym
    else
      mustache :edit
    end
  end

  post '/:name' do
    db = Mongo::Connection.new(config["mongo_host"]).db(config["mongo_db"])
    #request.body.rewind
    p params["action"]
    p params['data']
    p params['data'].encoding
    data = JSON.parse params['data'].force_encoding("utf-8")
    p data['author']
    p data['author'].encoding
    #data = JSON.parse request.body.read.force_encoding("utf-8")
    db[params[:name]].insert(data)
    'Success'
  end
end
