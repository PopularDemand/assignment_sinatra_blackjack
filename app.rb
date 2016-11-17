#!/usr/bin/env ruby
require 'sinatra'
require 'sinatra/reloader'
require 'pry-byebug'
require 'erb'
require 'json'

enable :sessions

get '/' do 
  erb :index
end

get '/blackjack' do
  # deck = Deck.new
  @players_hand = session[:players_hand] ? JSON.parse(session[:players_hand]) : [[2, 'H'],[10, 'C']]
  @dealers_hand = session[:dealers_hand] ? JSON.parse(session[:dealers_hand]) : [[7, 'S'],[4, '◆']] #deck.draw(2)

  session[:players_hand] = @players_hand.to_json
  session[:dealers_hand] = @dealers_hand.to_json
  erb :blackjack # uses @players_hand and @dealers_hand
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
  redirect "/blackjack"
end

get '/blackjack/hit' do 
  # instantiate game
  players_hand = JSON.parse(session[:players_hand])
  dealers_hand = JSON.parse(session[:dealers_hand])
  # draw from deck 
  players_hand << [5, 'C'] # deck.draw
  session[:players_hand] = players_hand.to_json
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

