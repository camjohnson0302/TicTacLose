class Space < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :player
  belongs_to :board
end
