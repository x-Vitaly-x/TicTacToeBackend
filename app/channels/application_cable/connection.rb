module ApplicationCable
  class Connection < ActionCable::Connection::Base
    #identified_by :current_player

    #def connect
    #  self.current_player = find_verified_player
    #end

    #private

    # find player based on player id, in other
    # cases this can be done through normal authentication,
    # TODO
    #def find_verified_player
      # p 'XXX'
      # p request.params
    #end
  end
end
