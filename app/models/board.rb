class Board < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :game, inverse_of: :board
  has_many 	 :spaces, inverse_of: :board

  after_create :make_spaces

  def make_spaces
  	(0...self.size**2).each do       
  		self.spaces << Space.create(index: Space.where("board_id = ?", self.id).count) 	
  	end
  end



  def available_space?
  	self.spaces.each do |space|
  		if space.player_id.nil?
  			return true 
  		end
  	end
  	false
  end
end
