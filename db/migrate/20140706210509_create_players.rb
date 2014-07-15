class CreatePlayers < ActiveRecord::Migration
  def change
  	create_table :players do |t|
  		t.integer :game_id
  		t.boolean :human
  		t.string :color
      t.timestamps
    end
  end
end
