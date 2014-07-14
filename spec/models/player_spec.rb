require 'spec_helper'

describe "player" do
	describe "#wins?" do
		it "returns true when the player has a complete row" do
			board = Board.create(size: 3)
			player = Player.create()
			board.spaces.each do |space|
				if space.index == 2 || 5 || 8
					player.spaces << space
				end
			end 
			expect(player.wins?).to eq(true)
		end
		it "returns false when the player doesn't wins" do
			player = Player.create()
			expect(player.wins?).to eq(false)
		end
	end

	describe "#owned_spaces" do
		it "returns an array of all the player's spaces' indices" do
			player = Player.create()
			(0..2).each do |idx|
				player.spaces << Space.new(index: idx)
			end
			expect(player.owned_spaces).to eq([0,1,2])
		end
	end

	describe "#win" do
		it "returns a winning square if available" do
			board = Board.create(size: 3)
			player = Player.create()
			board.spaces.each do |space|
				if space.index == 2 || space.index == 5
					player.spaces << space
				end
			end 
			expect(player.win.index).to eq(8)
		end
	end

	describe "#block" do
		it "stops the opponent from winning" do
			board = Board.create(size: 3)
			player = Player.create()
			player2 = Player.create(human: true)
			board.spaces.each do |space|
				if space.index == 2 || space.index == 5
					player2.spaces << space
				end
			end 
			expect(player.block.index).to eq(8)
		end
	end

	describe "#first_open_space" do
		it "chooses the first available space" do
			board = Board.create(size: 3)
			player = Player.create()
			game = Game.create()
			game.players << player
			game.board = board
			opponent_space = board.spaces.where("index = ?",0).last
			player2 = Player.create()
			player2.spaces << opponent_space
			expect(player.first_open_space.index).to eq(1)
		end	
	end

	describe "#fork" do
		it "creates a fork if possible" do
			board = Board.create(size: 3)
			player = Player.create()
			opponent = Player.create()
			board.spaces.each do |space|
				if space.index == 4 || space.index == 8
					player.spaces << space
				end
				if space.index == 3 || space.index == 0 || space.index == 2
					opponent.spaces << space
				end
			end 
			expect(player.fork.index).to eq(7)
		end
	end

	describe "#block_fork" do
		it "stops the opponent from creating a fork" do
			board = Board.create(size: 3)
			player = Player.create()
			opponent = Player.create(human: true)
			board.spaces.each do |space|
				if space.index == 4
					player.spaces << space
				end
				if space.index == 5 || space.index == 6
					opponent.spaces << space
				end
			end 
			expect(player.block_fork.index).to eq(8)
		end
	end

	describe "#first_move" do
		let (:board) {Board.create(size: 3)}
		let (:game) {Game.create()}
		let (:player) {Player.create(game_id: game.id)}
		let (:opponent) {Player.create(game_id: game.id)}

		it "chooses the center square if the other player didn't" do
			board.spaces.each do |space|
				if space.index == 1
					opponent.spaces << space
				end
			end 
			expect(player.first_move.index).to eq(4)
		end	

		it "takes the first open space if the opponent took the middle" do
			board.spaces.each do |space|
				if space.index == 4
					opponent.spaces << space
				end
			end 
			expect(player.first_move.index).to eq(0)
		end	
	end

	describe "#second_move" do
		let (:board) {Board.create(size: 3)}
		let (:game) {Game.create()}
		let (:player) {Player.create(game_id: game.id)}
		let (:opponent) {Player.create(game_id: game.id)}

		it "chooses the top right corner for its second turn if it went first and it is available" do
			board.spaces.each do |space|
				if space.index == 0 
					player.spaces << space
				end
				if space.index == 1
					opponent.spaces << space
				end
			end 
			expect(player.second_move.index).to eq(2)
		end	

		it "takes the bottom left corner for its second turn if it went first and top right is not available" do
			board.spaces.each do |space|
				if space.index == 0 
					player.spaces << space
				end
				if space.index == 2
					opponent.spaces << space
				end
			end 
			expect(player.second_move.index).to eq(6)
		end
	end
end