class Player < ActiveRecord::Base
  belongs_to :game, inverse_of: :players
  has_many :spaces, inverse_of: :player
  has_many :wins, class_name: :games

  def select_response #case this?
  	if self.spaces.empty?
  		space = self.first_move
  	elsif self.spaces.count == 1
  		space = self.second_move
  	elsif self.win
  		space = self.win
  	elsif self.block #&& !self.win
  		space = self.block
  	elsif self.fork #&& !self.win && !self.block
  		space = self.fork
  	elsif self.block_fork
  		space = self.block_fork
  	else
  		space = self.first_open_space
  	end
  	self.spaces << space
  	return space
  end



  def win #extract methods in win/block
  	Game.winning_sets.each do |win_set|
  		remainder = (win_set-self.space_array)
  		if remainder.length == 1
  			space = Space.where("index = ?",remainder[0]).last
  			if space.available?
  				# self.spaces << space
  				return space
  			end
  		end
  	end
  	nil
  end


  def block
  	Game.winning_sets.each do |win_set|
  		human = Player.where("human = ?",true).last
  		remainder = (win_set-human.space_array)
  		if remainder.length == 1
  			space = Space.where("index = ?",remainder[0]).last
				if space.available?
					# self.spaces << space
  				return space
  			end
  		end
  	end
  	nil
  end

  def first_open_space
  	(0...Board.last.size**2).each do |idx| #remove hard coding
  		space = Space.where("index = ?",idx).last
  		puts space.board
  		if space.available?
  			# self.spaces << space
  			return space
  		end
  	end
  end

  def fork #extract methods in these fork methods
  	available_spaces = Space.where("board_id = ? AND player_id is ?",Board.last.id,nil)
  	possible_wins = Hash.new {0}
  	available_spaces.each do |space|
  		Game.winning_sets.each do |win_set|
  			if (win_set - self.space_array).map{|index| Space.where("board_id = ? AND index = ?",Board.last.id,index).last.available? }.include?(false)
  				next
  			end
  			remainder = (win_set-(self.space_array+[space.index]))
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
  			if (win_set - human.space_array).map{|index| Space.where("board_id = ? AND index = ?",Board.last.id,index).last.available? }.include?(false)
  				next
  			end
  			remainder = (win_set-(human.space_array+[space.index]))
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
  	if Space.where("index = ?",4).last.player.nil? && !Player.where("human = ?",true).last.spaces.empty?
  		space = Space.where("index = ?",4).last
  	else
  		space = self.first_open_space
  	end
  end

  #fix. shouldn't  always make this play
  def second_move
  	if self.spaces.count == 1 && Player.where("human = ?",true).last.spaces.count
  		puts Player.where("human = ?",true).last.spaces.count
	  	if Space.where("index = ?",2).last.player	
	  		return Space.where("index = ?",6).last
	  	else
	  		return Space.where("index = ?",2).last
	  	end
 	  end
  end

  def space_array
  	space_array = []
  	self.spaces.each do |space|
  		space_array << space.index
  	end
  	space_array
  end

  def win?
  	Game.winning_sets.each do |win_set|
  		remainder = (win_set-self.space_array)
  		if remainder.length == 0
  			return true
  		end
  	end
  	false
  end
end
