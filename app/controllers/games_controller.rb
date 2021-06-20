class GamesController < ApplicationController
  before_action :require_game, only: %i[show update destroy make_move]

  def create
    player = Player.find_by_player_name(create_params['player_name']);
    if player
      game = Game.create(status: 'created', x_player_id: player.id);
      GameUpdatesChannel.push_update game
      render json: nil, status: 201
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

  def update
    @game.update(update_params)
    GameUpdatesChannel.push_update @game
    render json: nil, status: 201
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
    render json: @game.full_json, status: 200, formats: :json
  end

  def make_move
    @game.make_move(move_params['placement'])
    GameUpdatesChannel.push_update @game
    render(json: nil, status: 201, formats: :json)
  end

  private

  def create_params
    params.require(:game).permit(:player_name)
  end

  def update_params
    params.require(:game).permit(:y_player_id)
  end

  def move_params
    params.require(:game).permit(placement: [])
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
