#!/usr/bin/env ruby

require 'sinatra'
require 'sinatra/reloader'
require 'pry-byebug'
require 'erb'
require 'json'

require './lib/deck'
require './lib/card'

enable :sessions

helpers do 

  def total(hand) 
    hand = hand.map do |card|
      Card.new(card[0], card[1])
    end
    total = hand.inject(0) do |sum, card|
      sum + card.value
    end
    # binding.pry
    total
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
  session[:busted] = nil
  session[:dealer_busted] = nil
  erb :bet
end

post '/blackjack/bet' do
  bankroll = session[:bankroll] ? session[:bankroll] : 1000
  bet = params[:bet].to_i
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
  unless session[:busted] # dont enter if the player busted
    until total(dealers_hand) > 16
      dealers_hand << deck.draw
    end
  end
  session[:dealer_busted] = true if total(dealers_hand) > 21
  session[:dealers_hand] = dealers_hand.to_json
  redirect '/blackjack/results'
end

get '/blackjack/results' do 
  @players_hand = JSON.parse(session[:players_hand])
  @dealers_hand = JSON.parse(session[:dealers_hand])
  bankroll = session[:bankroll]
  bet = session[:bet]
  binding.pry

  if session[:busted]
    @winner = "dealer"
  elsif session[:dealer_busted]
    @winner = "player"
  else
    @winner = total(@players_hand) > total(@dealers_hand) ? "player" : "dealer"
  end

  if @winner == "player" 
    bankroll += bet
  else
    bankroll -= bet
  end

  session[:bankroll] = bankroll
  # binding.pry
  @bet = bet
  @bankroll = bankroll
  erb :results
end

