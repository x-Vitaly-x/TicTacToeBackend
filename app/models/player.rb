class Player < ApplicationRecord
  validates_presence_of :player_name
  validates_uniqueness_of :player_name
end
