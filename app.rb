require 'sinatra'
require 'sinatra/reloader'
require 'pry-byebug'

get '/' do 
  erb :index
  sleep(2)
  redirect to("blackjack")
end

get '/blackjack' do
  # if session[:player] reinstantiate game
  # else deal for the player and dealer
  erb :main
end