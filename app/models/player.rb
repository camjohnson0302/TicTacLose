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
  	elsif self.block_fork
  		best_move = self.block_fork
  	elsif self.spaces.empty?
  		best_move = self.first_move
  	elsif self.spaces.count == 1
  		best_move = self.second_move
  	else
  		best_move = self.first_open_space
  	end
  	self.spaces << best_move
  	return best_move
  end

  def win
  	Game.winning_sets.each do |winning_set|
  		spaces_needed = (winning_set - self.owned_spaces)
  		if spaces_needed.length == 1
  			space = Space.where("index = ?",spaces_needed[0]).last
  			if space.available?
  				return space
  			end
  		end
  	end
  	nil
  end

  def block
  	Game.winning_sets.each do |winning_set|
  		human = Player.where("human = ?",true).last
  		spaces_needed = (winning_set-human.owned_spaces)
  		if spaces_needed.length == 1
  			space = Space.where("index = ?",spaces_needed[0]).last
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
  	human = Player.where("human = ?",true).last
  	available_spaces.each do |space|
  		Game.winning_sets.each do |win_set|
  			if (win_set - human.owned_spaces).map{|index| Space.where("board_id = ? AND index = ?",Board.last.id,index).last.available? }.include?(false)
  				next
  			end
  			remainder = (win_set-(human.owned_spaces+[space.index]))
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
  	if Space.where("index = ?",4).last.available? && Player.where("game_id = ? AND NOT id = ? ",self.game_id,self.id).last.spaces.length > 0
  		return Space.where("index = ?",4).last
  	else
  		return self.first_open_space
  	end
  end

  def second_move
  	if self.spaces.length == 1 && Player.where("game_id = ? AND NOT id = ? ",self.game_id,self.id).last.spaces.length > 0
	  	if Space.where("index = ?",2).last.available?
	  		return Space.where("index = ?",2).last
	  	else
	  		return Space.where("index = ?",6).last
	  	end
 	  end
 	  nil
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
  	owned_spaces = []
  	self.spaces.each do |space|
  		owned_spaces << space.index
  	end
  	owned_spaces
  end

  def wins?
  	Game.winning_sets.each do |winning_set|
  		spaces_needed = (winning_set - self.owned_spaces)
  		if spaces_needed.length == 0
  			return true
  		end
  	end
  	false
  end
end
