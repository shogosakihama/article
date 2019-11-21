require 'sinatra'
require 'sinatra/reloader'
require 'erb'
require 'active_record' #test
require 'pg'   #test
require 'sinatra/cookies'

enable :sessions

#  json/ruby
require 'net/http'
require 'uri'
require 'json'
require 'pry'

# mail
require 'gmail'


# mail


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
  validates :email,:password, presence: true
end

class Inquirie < ActiveRecord::Base
  # validates :email,presence: true
end



get '/json' do
  @items = []
  @session =session[:name]
  erb :json
end

post '/json/search' do
  uri = URI.encode("https://www.googleapis.com/books/v1/volumes?q=#{params[:book_name]}")
  uri = URI.parse(uri)
  json = Net::HTTP.get(uri)
  result = JSON.parse(json)
  @session =session[:name]
  # @result = result["items"].first["volumeInfo"]["imageLinks"]["thumbnail"]
  # @result2 = result["items"].second["volumeInfo"]["imageLinks"]["thumbnail"]
  # @result3 = result["items"].third["volumeInfo"]["imageLinks"]["thumbnail"]
  # @result4 = result["items"].fourth["volumeInfo"]["imageLinks"]["thumbnail"]
  # @result5 = result["items"].fifth["volumeInfo"]["imageLinks"]["thumbnail"]
 
  if result["items"] == nil 
    redirect to ('/json')
  end
    @items = result["items"].map do |item|
      begin
      item["volumeInfo"]["imageLinks"]["thumbnail"]
      rescue
        redirect to ("/json")
      end
    end
  

  erb :json
end

post '/new' do
  @session =session[:name]
  @url = params["url"]
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
    # unless mail.empty? || pass.empty?
   
      users = User.all
      users.each do |user|
        if user[:email] != nil
          if user[:email] == mail
            if user[:password] == pass
              @user = user
              session[:name] = user[:name]
              @session =session[:name]
              return erb :mypage
            else 
              redirect to ('/')
              # return erb :review
            
            end
            redirect to ('/')
          
          end
        end
      
      end
      redirect to ('/')  
    erb :test
  end

  get '/login' do
    erb :login
  end

 

  post '/signup' do
    user = User.new
    # ({name: params['name'], email: params['email'], password: params['password']})
    user.name = params['name']
    user.email = params['email']
    user.password = params['password']
    begin
      if user.save
        
         session[:name] = params['name']
         @session =session[:name]
         return erb :mypage
       
         erb :test
        end
        redirect "/" 

        erb :test
      rescue
        redirect "/" 
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

get '/destroy/acount' do
  @session =session[:name]
  session[:name] = nil
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
  # @url = params[:img_url]
  @session =session[:name]
  # @result = result["items"].first["volumeInfo"]["imageLinks"]["thumbnail"]
  post = Post.create({title: params['title'], content: params['content'], user_name: @session, img_url: params['img_url']})

  # @img_url = params[:book_name]
  # redirect "/video"
  ret = sleep 5
  puts ret
  redirect "/show/#{post.id}"
end

get '/show/:id' do
  # @result = result["items"].first["volumeInfo"]["imageLinks"]["thumbnail"]
  # @result2 = result["items"].second["volumeInfo"]["imageLinks"]["thumbnail"]
  # @result3 = result["items"].third["volumeInfo"]["imageLinks"]["thumbnail"]
    @post = Post.find(params['id'])
    @session =session[:name]
    @image = @url
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


# get '/video' do
#   erb :video
# end

get '/inquiry' do
  erb :inquiry
end



post '/inquiry' do
  # inquiry = Inquirie.create({email: params['email'], content: params['content']})
  inquiry = Inquirie.new
  inquiry.email = params['email']
  inquiry.content = params['content']
  if inquiry.save
      email = params[:email]
      content = params[:content]

      gmail = Gmail.new('goshalways@gmail.com', 'thokwzqlnksbqtme')
      ret = gmail.deliver do
        to "goshalways@gmail.com"
        from email
        subject "subject"
        text_part do
          body content
        end
      end
    end
    # redirect to ('/inquiry') 
    erb :inquiry
end


get '/menu' do
  @session =session[:name]
  erb :menu
end