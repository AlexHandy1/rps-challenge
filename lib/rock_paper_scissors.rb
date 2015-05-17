require 'sinatra/base'
require_relative 'game'

class RockPaperScissors < Sinatra::Base
 set :views, proc { File.join(root, '..', 'views') }
 enable :sessions

 @@game = Game.new Player

  get '/' do
    erb :index
  end

  get '/game/player1' do
    session['player'] = 'player_1'
     @error = params[:error]
    if @error.nil?
      @message = "What's your name?"
    else
      @message = "Please put in a valid name"
    end
    erb :new_game
  end

  get '/game/player2' do
    session['player'] = 'player_2'
     @error = params[:error]
    if @error.nil?
      @message = "What's your name?"
    else
      @message = "Please put in a valid name"
    end
    erb :new_game
  end

  post '/game/welcome' do
    @name = params[:name]

    if @name.empty? && session['player'] == 'player_1'
      redirect to '/game/player1?error=invalidname'
    elsif @name.empty? && session['player'] == 'player_2'
      redirect to '/game/player2?error=invalidname'
    else
      session['player'] = @name
      erb :game
    end
  end

  get '/game/turn' do
    erb :game_turn
  end

  post '/game/turn' do
    @player_1_turn = params[:choice1]
    @player_2_turn = params[:choice2]
    @@game.player_1.take_a_turn @player_1_turn
    @@game.player_2.take_a_turn @player_2_turn
    @result = @@game.process_turn

    if @result == "Go again"
      @message = "You matched, go again"
    else
      @message = nil
    end

    if @result == "Game already won" && @@game.player_1.winner?
      redirect to '/game/player1/win'
    elsif @result == "Game already won" && @@game.player_2.winner?
      redirect to '/game/player2/win'
    end

    erb :game_turn
  end

  get '/game/player1/win' do
    "Player 1 wins"
  end

  get '/game/player2/win' do
    "Player 2 wins"
  end
  # start the server if ruby file executed directly
  run! if app_file == $0
end
