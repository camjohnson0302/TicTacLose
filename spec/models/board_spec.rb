require 'spec_helper'

describe "board" do

	let(:board) { Board.new(size: 3) }

	describe "#make_spaces" do 
		
		let(:board) { Board.new(size: 3) }
		
		it "creates a number of spaces equal to board.size squared" do
			spaces_in_db_before = Space.all.count
			board.make_spaces
			spaces_in_db_after = Space.all.count
			expect(spaces_in_db_after).to eq(spaces_in_db_before + board.size**2)
		end
	end

	describe "after creation" do
		
		let(:board) { Board.create(size: 3) }
		
		it "has spaces proportional to its size once it is created" do
			expect(board.spaces.length).to eq(board.size**2)
		end
	end

	describe "#available_space?" do
		
		let(:board) {Board.create(size:1)}

	  it "returns true when there is an available space(player_id = nil)" do
			expect(board.available_space?).to eq(true)
		end

		it "returns false when there are no available spaces" do
			board.spaces.first.update(player: Player.create())
			expect(board.available_space?).to eq(false)	
		end
	end

	describe "#available_spaces" do
		
		let(:board) {Board.create(size:2)}

	  it "returns an array of available indices" do
	  	board.spaces.last.player = Player.create()
			expect(board.available_spaces).to eq([0,1,2])
		end
	end
end