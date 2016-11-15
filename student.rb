require 'sinatra'
require 'dm-core'
require 'dm-migrations'

configure do
  enable :sessions
  set :username,"yuan"
  set :password,"newnew"
end

DataMapper.setup(:default, "sqlite3://#{Dir.pwd}/students.db")

class Student
  include DataMapper::Resource
  property :id, Serial
  property :name, String
  property :birthdate, Date
  property :age, Integer
  property :hometown, String

def birthdate=date
    super Date.strptime(date, '%m/%d/%Y')
  end
end

DataMapper.finalize

get '/login' do
  slim :login
end

get '/students' do
  if session[:admin]
    @students = Student.all
    slim :students
  else
    redirect to ('/login')
  end
end

get '/students/new' do
    @student = Student.new
    slim :new_student
end

get '/students/:id' do
  @student = Student.get(params[:id])
  slim :show_student
end

get '/students/:id/edit' do
  @student = Student.get(params[:id])
  slim :edit_student
end

get '/logout' do
  session.clear
  redirect to ('/login')
end

post '/students' do  
  student = Student.create(params[:student])
  redirect to("/students/#{student.id}")

end

post '/login' do
  if params[:username] == settings.username &&
     params[:password] == settings.password

     session[:admin] = true
     redirect to ('/students')
  else
     slim :login
  end
end

put '/students/:id' do
  student = Student.get(params[:id])
  student.update(params[:student])
  redirect to("/students/#{student.id}")
end

delete '/students/:id' do
  Student.get(params[:id]).destroy
  redirect to('/students')
end
