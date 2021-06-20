class GameUpdatesChannel < ApplicationCable::Channel

  def subscribed
    stream_from 'game_updates_channel'
  end

  def unsubscribed
  end

  def self.push_update(game)
    ActionCable.server.broadcast('game_updates_channel', game.full_json)
  end
end
