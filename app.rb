#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/reloader'
require 'pry-byebug'
require 'erb'
require 'json'

require './lib/deck'

enable :sessions

helpers do 

  def total(hand) 
    hand.inject(0) do |sum, card|
      sum + card[0]
    end
  end

end

get '/' do 
  erb :index
end

get '/blackjack' do
  deck = Deck.new
  @players_hand = session[:players_hand] ? JSON.parse(session[:players_hand]) : deck.draw(2)
  @dealers_hand = session[:dealers_hand] ? JSON.parse(session[:dealers_hand]) : deck.draw(2)

  session[:players_hand] = @players_hand.to_json
  session[:dealers_hand] = @dealers_hand.to_json
  session[:deck] = deck.cards.to_json
  erb :blackjack # uses @players_hand and @dealers_hand
end

get '/blackjack/bet' do
  # clear out session variables 
  @bankroll = session[:bankroll] || 1000
  session[:players_hand] = nil 
  session[:dealers_hand] = nil 
  session[:deck] = nil 
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
  deck = Deck.new(JSON.parse(session[:deck]))
  players_hand = JSON.parse(session[:players_hand])
  dealers_hand = JSON.parse(session[:dealers_hand])
  players_hand << deck.draw
  session[:players_hand] = players_hand.to_json
  session[:deck] = deck.cards.to_json
  if total(players_hand) > 21
    session[:busted] = true
    redirect '/blackjack/stay'
  else
    redirect '/blackjack' 
  end
end

get '/blackjack/stay' do 
  deck = Deck.new(JSON.parse(session[:deck]))
  dealers_hand = JSON.parse(session[:dealers_hand])
  unless session[:busted]
    until total(dealers_hand) > 16
      dealers_hand << deck.draw
    end
  end
  session[:dealers_hand] = dealers_hand.to_json
  redirect '/blackjack/results'
end

get '/blackjack/results' do 
  @players_hand = JSON.parse(session[:players_hand])
  @dealers_hand = JSON.parse(session[:dealers_hand])
  if session[:busted]
    @winner = "dealer"
  elsif total(@dealers_hand) > 21
    @winner = "player"
  else
    @winner = total(@players_hand) > total(@dealers_hand) ? "player" : "dealer"
  end
  @bet = session[:bet]
  @bankroll = session[:bankroll]
  erb :results
end

