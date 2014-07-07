get '/' do
	@board = Board.new(size: 3)
  erb :game
end