require "test_helper"

class GamesControllerTest < ActionDispatch::IntegrationTest
  def setup
    @correct_params = {
      game_state: {
        player_id: 1,
        placement: [0, 0]
      }
    }
    Game.first.generate_board.save!
  end

  test "should be able to make a move" do
    put "/games/#{Game.first.id}", params: @correct_params, as: :json
    # p Game.first.board
    assert_response :success
  end
end
