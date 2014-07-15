require 'spec_helper'

describe "game" do
	
	let(:game) { Game.new() }


	describe "#self.winning_sets" do
		it "returns an array of winning set arrays" do
			expect(Game.winning_sets).to eq([[0,1,2],[3,4,5],[6,7,8],[0,3,6],[1,4,7],[2,5,8],[0,4,8],[2,4,6]])
		end
	end

	describe "#over?" do
		
		let(:board) {Board.create(size: 3)}

		it "returns true when a player has a winning set" do
			game.board = board
			game.players << Player.create()
			board.spaces.each do |space|
				if space.index == 2 || 5 || 8
					game.players.first.spaces << space #law of demeter?
				end
			end 
			expect(game.over?).to eq(true)
		end

		it "returns true when no spaces remain" do
			game.board = Board.create(size:1)
			space = game.board.spaces.last
			player = Player.create()
			player.spaces << space
			expect(game.over?).to eq(true)
		end

		it "returns false when nobody has 3 in a row and a space remains" do
			game.board = board
			expect(game.over?).to eq(false)
		end 
	end





end
