class GamesController < ApplicationController
  before_action :require_game, only: %i[show update destroy]

  def create
  end

  def update
    @game.update_game_state(game_state_params[:player_id], game_state_params[:placement])
  end

  def delete
  end

  def list
  end

  def show
  end

  private

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
