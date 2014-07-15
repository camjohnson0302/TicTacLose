get '/' do
	@game = Game.create()
	@game.board = Board.create(size: 3)
  @game.players << Player.create(human: true, color:"red")
  @game.players << Player.create(human: false, color:"blue") 
  erb :game
end


post '/' do
	content_type :json
	
	@game = Game.last
	@human = Player.where("human = ?", true).last
	@robot = Player.where("human = ?", false).last

	unless params[:skip] == "true" &&	@robot.spaces.empty?
	@space = Space.where("index = ?",params[:index].to_i).last
	@human.spaces << @space
	end
	

	unless @game.over?
		choice = @robot.take_turn!
		if @robot.wins?
			return {:gameOver => true, :index => choice.index}.to_json
		end
		{:gameOver => false, :index => choice.index}.to_json
	else
		{:gameOver => true}.to_json
	end
end