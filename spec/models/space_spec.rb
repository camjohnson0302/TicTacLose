require 'spec_helper'


describe "space" do
	
	describe "#available?" do

		let(:space) {Space.new()}

		it "returns true when the player is nil" do
			space.player = nil
			expect(space.available?).to eq(true)
		end

		it "returns false when it belongs to a player" do
			space.player = Player.create()
			expect(space.available?).to eq(false)
		end
	end
end