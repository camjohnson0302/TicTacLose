class Player < ActiveRecord::Base
  # Remember to create a migration!
  belongs_to :game
  has_many :spaces
  has_many :wins, class_name: :games
end
