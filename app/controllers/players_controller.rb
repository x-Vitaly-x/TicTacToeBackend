class PlayersController < ApplicationController
  def create
    player = Player.create(player_params)
    if player.persisted?
      render json: player.as_json, status: 200, formats: :json
    else
      @errors = [
        {
          code: 'not_allowed',
          detail: 'Name must not be blank and must be unique'
        }
      ]
      render('games/errors', formats: :json, status: 404)
    end
  end

  def self
    player = Player.find_by_player_name(player_params['player_name'])
    if player
      render json: player.as_json, status: 200, formats: :json
    else
      @errors = [
        {
          code: 'not_existing',
          detail: 'Player does not exist'
        }
      ]
      render('games/errors', formats: :json, status: 404)
    end
  end

  private

  def player_params
    params.permit(:player_name)
  end
end
