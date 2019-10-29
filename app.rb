require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'active_record' #test
require 'pg'   #test
enable :sessions


ActiveRecord::Base.configurations = YAML.load_file("database.yml")
ActiveRecord::Base.establish_connection(:development)

client = PG::connect(      #test
  :host => "localhost",
  :user => 'shogo_sakihama', :password => '',
  :dbname => "memo")

  
  
  
class Post < ActiveRecord::Base
end

class User < ActiveRecord::Base
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

post '/signup' do
  post = User.create({name: params['name'], email: params['email'], password: params['password']})
  redirect "/"
end

get '/destroy/:id' do
  Post.find(params['id']).destroy
  redirect '/b'
end




get '/login' do
  erb :login
end


post '/login' do
mail = params[:email]
pass = params[:password]
users = User.all
users.each do |user|
  if user[:email] == mail
    if user[:password] == pass
      @user = user
      session[:name] = user[:name]
      return erb :mypage
    end
  end
end
redirect to ('/login')
end

get '/mypage' do
@user = { name: "No User" }
users.each do |user|
  if user[:name] == session[:name]
    @user = user
  end
end
erb :mypage
end
