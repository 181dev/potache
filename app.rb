# -*- coding: utf-8 -*-

require 'sinatra/base'
require 'sinatra/mustache'
require 'mongo'
require 'yaml'
require 'json'

# Self editing application framework
# POTACHE
# MIT
class App < Sinatra::Base
  include Mongo
  COLL_SYSTEM = 'POTACHE_SYSTEM'
  set :environment, :production

  configure :development do
  end

  configure :production do
  end

  def get_db
    @client = MongoClient.from_uri
    @db     = @client.db['potache']
  end

  get '/' do
    @colls = []
    get_db()
    @db[COLL_SYSTEM].find.each{|x|
      @colls << x["name"]
    }
    mustache :index
  end

  get '/edit/:name' do
    get_db()
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
    get_db()
    @name = params[:name]
    @body = params[:body]
    File.write("./views/" + @name + ".mustache" , @body)
    if !(["layout","edit","index","develop","edit"].include?(@name)) then
      @db[COLL_SYSTEM].update({"name"=>@name}, {"name"=>@name}, :upsert=>true)
    end
    "Success"
  end

  get '/:name' do
    get_db()
    content_type :html, 'charset' => 'utf-8'
    @name = params[:name]
    if FileTest.exist?("./views/" + @name + ".mustache") then
      @items = @db[@name].find.sort([:_id, :desc]).to_a
      mustache @name.to_sym
    else
      mustache :edit
    end
  end

  post '/:name' do
    get_db()
    p params["action"]
    data = JSON.parse params['data'].force_encoding("utf-8")
    @db[params[:name]].insert(data)
    'Success'
  end
end
