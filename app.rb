require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'active_record' #test
require 'pg'   #test
require 'sinatra/cookies'
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

get '/searchbox' do
  @posts = Post.all
  erb :searchbox
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
        @session =session[:name]
        return erb :mypage
      end
    end
  end
  redirect to ('/login')
  end

  post '/signup' do
    post = User.create({name: params['name'], email: params['email'], password: params['password']})
    mail = params[:email]
    pass = params[:password]
    users = User.all
    users.each do |user|
      if user[:email] == mail
        if user[:password] == pass
          @user = user
          session[:name] = user[:name]
          @session =session[:name]
          return erb :mypage
        end
      end
    end
    redirect to ('/')
  end

get '/log_out' do
  @session =session[:name]
  erb :log_out
end

get '/log_out_do' do
  @session =session[:name]
  erb :log_out_do
end

post '/log_out' do
  session[:name] = nil
  redirect '/'
end

get '/show/:id' do
    @post = Post.find(params['id'])
    @session =session[:name]
    erb :show
end

get '/edit/:id' do
  @post = Post.find(params['id'])
  @session =session[:name]
  erb :article
end

get '/' do
  @session =session[:name]
  erb :top
end

get '/b' do
  @session =session[:name]
  @posts = Post.all
  erb :review
end

post '/update/:id' do
  post = Post.find(params['id'])
  @session =session[:name]

  post.title = params['title']
  post.content = params['content']
  post.save

  redirect "/show/#{params['id']}"
end

get '/new' do
  @session =session[:name]
  erb :new
end

post '/create' do
  @session =session[:name]
  post = Post.create({title: params['title'], content: params['content']})
  redirect "/show/#{post.id}"
end

get '/destroy/:id' do
  @session =session[:name]
  Post.find(params['id']).destroy
  redirect '/b'
end

get '/login' do
  erb :login
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
