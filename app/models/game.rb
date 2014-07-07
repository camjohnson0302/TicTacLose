class Game < ActiveRecord::Base
  # Remember to create a migration!
  has_many :players
  belongs_to :winner, class_name: :player
end
