class GameUpdatesChannel < ApplicationCable::Channel
  def subscribed
    stream_from "game_updates_channel"
  end

  def unsubscribed
  end
end
