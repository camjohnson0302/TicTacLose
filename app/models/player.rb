class Player < ActiveRecord::Base
  belongs_to :game, inverse_of: :players
  has_many :spaces, inverse_of: :player
  has_many :wins, class_name: :games

  def take_turn
  	if self.win
  		best_move = self.win
  	elsif self.block
  		best_move = self.block
  	elsif self.fork
  		best_move = self.fork
    elsif self.block_corner_fork
      best_move = self.block_corner_fork
  	elsif self.block_fork
  		best_move = self.block_fork
  	elsif self.spaces.empty?
  		best_move = self.first_move
  	else
  		best_move = self.first_open_space
  	end
  	self.spaces << best_move
  	return best_move
  end

  def win
  	self.spaces_needed.each do |still_needed|
  		if still_needed.length == 1
  			space = Space.where("index = ?",still_needed[0]).last
  			if space.available?
  				return space
  			end
  		end
  	end
  	nil
  end

  def block
    self.opponent.spaces_needed.each do |still_needed|
  		if still_needed.length == 1
  			space = Space.where("index = ?",still_needed[0]).last
				if space.available?
  				return space
  			end
  		end
  	end
  	nil
  end

  def fork
  	available_spaces = Space.where("board_id = ? AND player_id is ?",Board.last.id,nil)
  	possible_wins = Hash.new {0}
  	available_spaces.each do |space|
  		Game.winning_sets.each do |win_set|
  			if (win_set - self.owned_spaces).map{|index| Space.where("board_id = ? AND index = ?",Board.last.id,index).last.available? }.include?(false)
  				next
  			end
  			remainder = (win_set-(self.owned_spaces+[space.index]))
  			if remainder.length == 1 
  				possible_wins[space.index]+=1
  			end
  		end
  	end
  	possible_wins.each_key do |possibility_index|
  		if possible_wins[possibility_index] > 1
  			return Space.where("index = ?",possibility_index).last
  		end
  	end
  	nil
  end

  def block_fork
  	available_spaces = Space.where("board_id = ? AND player_id is ?",Board.last.id,nil)
  	possible_wins = Hash.new {0}
  	available_spaces.each do |space|
  		Game.winning_sets.each do |win_set|
  			if (win_set - self.opponent.owned_spaces).map{|index| Space.where("board_id = ? AND index = ?",Board.last.id,index).last.available? }.include?(false)
  				next
  			end
  			remainder = (win_set-(self.opponent.owned_spaces+[space.index]))
  			if remainder.length == 1 
  				possible_wins[space.index]+=1
  			end
  		end
  	end
  	possible_wins.each_key do |possibility_index|
  		if possible_wins[possibility_index] > 1
  			return Space.where("index = ?",possibility_index).last
  		end
  	end
  	nil
  end

  def first_move
  	if Space.where("index = ?",4).last.available? && self.opponent.spaces.length > 0
  		return Space.where("index = ?",4).last
  	else
  		return self.first_open_space
  	end
  end

  def first_open_space
  	(0...Board.last.size**2).each do |index|
  		space = Space.where("index = ?",index).last
  		if space.available?
  			return space
  		end
  	end
  end

  def owned_spaces
  	self.spaces.map  {|space| space.index}
  end

  def wins?
  	self.spaces_needed.each do |still_needed|
  		if still_needed.length == 0
  			return true
  		end
  	end
  	false
  end

  def spaces_needed
    Game.winning_sets.map  {|winning_set| winning_set - self.owned_spaces}
  end

  def block_corner_fork
    if self.owned_spaces.include?(4) && self.opponent.has_corner
      if Space.where("index = ?",7).last.available?
        return Space.where("index = ?",7).last
      end
    end
  end

  def has_corner
    return self.owned_spaces.include?(0 || 2 || 6 || 8)
  end

  def opponent
    Player.where("game_id = ? AND NOT id = ? ",self.game_id,self.id).last
  end
end