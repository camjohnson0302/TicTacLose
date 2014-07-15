require 'spec_helper'

describe "player" do
	describe "#win?" do
		xit "returns true when the player has three in a row" do
			board = Board.create(size: 3)
			player = Player.create()
			board.spaces.each do |space|
				if space.index == 2 || 5 || 8
					player.spaces << space
				end
			end 
		end
		xit "returns false when the player doesn't" do
			player = Player.create()
			expect(player.win?).to eq(false)
		end
	end

	describe "#space_array" do
		xit "returns an array of all the player's spaces' indices" do
			player = Player.create()
			(0..2).each do |idx|
				player.spaces << Space.new(index: idx)
			end
			expect(player.space_array).to eq([0,1,2])
		end
	end

	describe "#win" do
		xit "returns a winning square if available" do
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
		xit "stops the opponent from winning" do
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
		xit "chooses the first available space" do
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
		xit "creates a fork if possible" do
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
		xit "stops the opponent from creating a fork" do
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
end