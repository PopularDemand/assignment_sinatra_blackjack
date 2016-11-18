class Deck

  attr_accessor :cards

  def initialize(cards=nil)
    @cards = cards || new_deck.shuffle
  end

  def draw(amount = 1)
    cards = []
    amount.times do
      cards << @cards.pop
    end
    if cards.length == 1
      cards.flatten
    else
      cards
    end
  end

  def new_deck
    (2..14).to_a.product(['♠','♥','♣','♦'])
  end

end