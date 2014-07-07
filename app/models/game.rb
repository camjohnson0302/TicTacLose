class Game < ActiveRecord::Base
  # Remember to create a migration!
  has_many :players
  belongs_to :winner, source: :player
end
