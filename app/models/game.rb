class Game < ActiveRecord::Base
  # Remember to create a migration!
  has_one :board, inverse_of: :game
  has_many :players, inverse_of: :game
  belongs_to :winner, class_name: :player


 

  def self.winning_sets # Needs to be abtracted out. Also potential clarity issue?
  	[[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]]
  end


  def over?
  	self.players.each do |player|
  		return true if player.win?
  	end
  	 return true if !self.board.available_space? #Law of Demeter?
  	false
  end


end
