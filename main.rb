require 'sinatra'
require 'slim'
require 'sass'
require './student'

get('/styles.css'){ scss :styles }

get '/' do
	slim :home
end

get '/about' do
	@title = "About"
	slim :about
end

get '/contact' do
	slim :contact
end

not_found do
  slim :not_found
end
