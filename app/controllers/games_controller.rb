class GamesController < ApplicationController
  before_action :require_game, only: %i[show update destroy]

  def create
    player = Player.find_by_player_name(create_params['player_name']);
    if player
      game = Game.create(status: 'created', x_player_id: player.id);
      render json: game.as_json, status: 200
    else
      @errors = [
        {
          code: 'not_allowed',
          detail: 'Player does not exist'
        }
      ]
      render('games/errors', formats: :json, status: 404)
    end
  end

  def test
    ActionCable.server.broadcast('test_channel', { xxx: 'tttt' })
    render json: nil, status: 201
  end

  def update
    @game.update(update_params)
    serialized_data = @game.as_json.serializable_hash
    ActionCable.server.broadcast 'game_updates_channel', serialized_data
  end

  def update_game_state
    @game.update_game_state(game_state_params[:player_id], game_state_params[:placement])
    render json: @game.as_json, status: 200, formats: :json
  end

  def index
    games = Game.all
    render json: games.map(&:as_json), status: 200
  end

  def destroy
    @game.destroy
    render(json: nil, status: 204, formats: :json)
  end

  def show
    render json: @game.as_json, status: 200, formats: :json
  end

  private

  def create_params
    params.require(:game).permit(:player_name)
  end

  def update_params
    params.require(:game).permit(:y_player_id)
  end

  def game_state_params
    params.require(:game_state).permit(:player_id, placement: [])
  end

  # check to see that given endpoint id is correct
  def require_game
    @game = Game.find_by_id(params.require(:id))
    return if @game

    @errors = [
      {
        code: 'not_found',
        detail: 'Requested game does not exist'
      }
    ]
    render('games/errors', formats: :json, status: 404)
  end
end
