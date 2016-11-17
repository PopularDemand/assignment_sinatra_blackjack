#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require 'pry-byebug'
require 'erb'

get '/' do 
  erb :index
end

get '/blackjack' do
  # unless session[:game] reinstantiate game
  	# instantiate player bankroll
  # else deal for the player and dealer
  # break down & store
  erb :blackjack
end

get '/blackjack/bet' do
	# instantiate game
	# show bankroll
	# ask player for bet amount
	# break down & store
	erb :bet
end

post '/blackjack/bet' do
	# instantiate game
	# decrement the bankroll
	# break down & store
	redirect "/blackjack"
end

get '/blackjack/hit' do 
  # instantiate game
  # draw from deck 
  # add drawn cardto player's hand 
  # break down & store 
  redirect '/blackjack'
end

get '/blackjack/stay' do 
  # instantiate game
  # dealer does his turns
  # break down & store
  redirect '/blackjack/results'
end

get '/blackjack/results' do 
  # displays results 
  # ask to play again 
end

