require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'active_record' #test
require 'pg'   #test
require 'sinatra/cookies'
# require 'action_mailer'
# require 'English'
enable :sessions

#  json/ruby
require 'net/http'
require 'uri'
require 'json'
require 'pry'



# --- json/ruby


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


# ActionMailer::Base.delivery_method = :smtp
# ActionMailer::Base.smtp_settings = {
#   address:   'smtp.example.net',
#   port:      587,
#   domain:    'example',
#   user_name: 'KitaitiMakoto',
#   password:  ($stderr.print 'password> '; gets.chomp)
# }

# class SampleMailer < ActionMailer::Base
#   def first_example(body)
#     mail(
#       to:      'goshalways@gmail.com',
#       from:    'goshalways@gmail.com',
#       subject: 'Mail from SampleMailer',
#       body:    body.to_s
#     )
#   end
# end

# if File.basename($PROGRAM_NAME) == File.basename(__FILE__)
#   SampleMailer.first_example('There is a body.').deliver
# end

get '/json' do

  
  # uri = URI.encode("https://www.googleapis.com/books/v1/volumes?q=#{params[:name]}")
  # uri = URI.parse(uri)
  # json = Net::HTTP.get(uri)
  # result = JSON.parse(json)

  # @aa = params[:name]
  @session =session[:name]
  # @result = result["items"].first["volumeInfo"]["imageLinks"]["thumbnail"]
  # @result2 = result["items"].second["volumeInfo"]["imageLinks"]["thumbnail"]
  # @result3 = result["items"].third["volumeInfo"]["imageLinks"]["thumbnail"]
  ## puts @result
  erb :json
end

def result 
  uri = URI.encode("https://www.googleapis.com/books/v1/volumes?q=#{params[:book_name]}")
  uri = URI.parse(uri)
  json = Net::HTTP.get(uri)
  result = JSON.parse(json)
end

post '/json/:name' do
  
  
  @session =session[:name]
  @result = result["items"].first["volumeInfo"]["imageLinks"]["thumbnail"]
  @result2 = result["items"].second["volumeInfo"]["imageLinks"]["thumbnail"]
  @result3 = result["items"].third["volumeInfo"]["imageLinks"]["thumbnail"]
  erb :json
end

post '/new/:book_name' do
  uri = URI.encode("https://www.googleapis.com/books/v1/volumes?q=#{params[:book_name]}")
  uri = URI.parse(uri)
  json = Net::HTTP.get(uri)
  result = JSON.parse(json)

  @session =session[:name]
  @result = result["items"].first["volumeInfo"]["imageLinks"]["thumbnail"]
  @result_a = 
  erb :new
end


get '/searchbox' do
  @session =session[:name]
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
          # redirect to ('/')
      end
    
  end

  get '/login' do
    erb :login
  end

 

  post '/signup' do
    post = User.create({name: params['name'], email: params['email'], password: params['password']})
    mail = params[:email]
    pass = params[:password]
    users = User.all
    users.each do |user|
      if user[:email] != nil
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
  end

get '/log_out' do
  @session =session[:name]
  erb :log_out
end

#  get '/unsubscribe' do
#   @session =session[:name]
#   erb :unsubscribe
# end

get '/destroy/acount/:name' do
  @session =session[:name]
  User.find_by(name: @session).destroy
  redirect '/'
end

get '/log_out_do' do
  @session =session[:name]
  erb :log_out_do
end

post '/log_out' do
  session[:name] = nil
  redirect '/'
end

post '/create' do
  @session =session[:name]
  @result = result["items"].first["volumeInfo"]["imageLinks"]["thumbnail"]
  post = Post.create({title: params['title'], content: params['content'], user_name: @session})
  @img_url = params[:user_name]
  redirect "/show/#{post.id}"
end

get '/show/:id' do
  @result = result["items"].first["volumeInfo"]["imageLinks"]["thumbnail"]
  @result2 = result["items"].second["volumeInfo"]["imageLinks"]["thumbnail"]
  @result3 = result["items"].third["volumeInfo"]["imageLinks"]["thumbnail"]
    @post = Post.find(params['id'])
    @session =session[:name]
    erb :show
end

get '/edit/:id' do
  @post = Post.find(params['id'])
  @session =session[:name]
  erb :edit
end

get '/' do
  @posts = Post.all
  @session =session[:name]
  erb :top
end

get '/b' do
  @session =session[:name]
  @posts = Post.all
  erb :review
end

get '/myposts' do
  @session =session[:name]
  @posts = Post.all
  erb :myposts
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
  # @result = result["items"].first["volumeInfo"]["imageLinks"]["thumbnail"]
  # @result2 = result["items"].second["volumeInfo"]["imageLinks"]["thumbnail"]
  # @result3 = result["items"].third["volumeInfo"]["imageLinks"]["thumbnail"]
  erb :new
end



get '/destroy/:id' do
  @session =session[:name]
  Post.find(params['id']).destroy
  redirect '/b'
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
