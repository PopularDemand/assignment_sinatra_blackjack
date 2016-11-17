require 'sinatra'
require 'sinatra/reloader'
require 'pry-byebug'
require 'erb'

get '/' do 
  erb :index 
end

get '/blackjack' do
  # if session[:player] reinstantiate game
  # else deal for the player and dealer
  # break down & store
  erb :blackjack
end

get '/blackjack/hit' do 
  # instantiate
  # draw from deck 
  # add drawn cardto player's hand 
  # break down & store 
  redirect '/blackjack'
end

get '/blackjack/stay' do 
  # instantiate 
  # dealer does his turns
  # break down & store
  redirect '/blackjack/results'
end

get '/blackjack/results' do 
  # displays results 
  # ask to play again 
end

