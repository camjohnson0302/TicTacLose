class CreatePlayers < ActiveRecord::Migration
  def change
  	create_table :players do |t|
  		t.integer :game_id
  		t.string :color
      t.timestamps
    end
  end
end
