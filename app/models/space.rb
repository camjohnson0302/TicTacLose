class Space < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :player, inverse_of: :spaces
  belongs_to :board, inverse_of: :spaces

  def available?
  	return self.player_id.nil?
  end
end
