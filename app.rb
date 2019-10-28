require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'active_record' #test
require 'pg'   #test

ActiveRecord::Base.configurations = YAML.load_file("database.yml")
ActiveRecord::Base.establish_connection(:development)

client = PG::connect(      #test
  :host => "localhost",
  :user => 'shogo_sakihama', :password => '',
  :dbname => "memo")

  
  
  
class Post < ActiveRecord::Base
end

get '/show/:id' do
    @post = Post.find(params['id'])
    erb :show
end

get '/edit/:id' do
  @post = Post.find(params['id'])
  erb :article
end

get '/' do
  erb :top
end

get '/b' do
  @posts = Post.all
  erb :review
end

get '/b' do
  @posts = Post.all
  erb :review
end

post '/update/:id' do
  post = Post.find(params['id'])

  post.title = params['title']
  post.content = params['content']
  post.save

  redirect "/show/#{params['id']}"
end

get '/new' do
  erb :new
end

post '/create' do
  post = Post.create({title: params['title'], content: params['content']})
  redirect "/show/#{post.id}"
end

get '/destroy/:id' do
  Post.find(params['id']).destroy
  redirect '/b'
end


post '/c' do
  @title =params[:title]
  @review =params[:review]
  erb :article
end