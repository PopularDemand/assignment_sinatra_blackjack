#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require 'pry-byebug'
require 'erb'

enable :sessions

get '/' do 
  erb :index
end

get '/blackjack' do
  players_hand = session[:players_hand]
  dealers_hand = session[:dealers_hand]
  # cards removed from deck
  # deck = Deck.new(players_hand, dealers_hand) 
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
  bankroll = session[:bankroll] ? session[:bankroll] : 1000
  bet = params[:bet].to_i
  bankroll -= bet
  session[:bet] = bet
  session[:bankroll] = bankroll
  binding.pry
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

