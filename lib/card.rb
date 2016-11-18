class Card

  attr_reader :value

  def initialize(number, suit) 
    @number = number
    @suit = suit
    @value = num_to_val
  end

  def num_to_val
    if @number <= 10 
      @number
    elsif @number > 10 && @number < 14 
      10
    else
      11
    end
  end

  def ace_low
    @value = 1
  end

  def render
    if @number > 1 && @number < 11 
      [@number, @suit]
    elsif @number == 11
      ['J', @suit]
    elsif @number == 12
      ['Q', @suit]
    elsif @number == 13
      ['K', @suit]
    else
      ['A', @suit]
    end    
  end

end