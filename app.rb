require 'sinatra'
require 'sinatra/reloader'
require 'erb'

get '/' do
  erb :article
end

get '/a' do
  erb :top
end

get '/b' do
  erb :review
end

post '/' do
  @title =params[:title]
  @review =params[:review]
  erb :article
end