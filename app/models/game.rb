class Game < ApplicationRecord
  BOARD_SIZE = 3 # classic tictactoe
  STATUSES = %w(created started finished cancelled)

  # status should be present and also one of the types. Analogue to enum use
  validates :status, presence: true, inclusion: { in: STATUSES }

  before_create :generate_board

  before_save :check_winner

  #
  # Prefill the board with empty values on game initialization.
  # Assumption is that player X starts first
  # #
  def generate_board
    self.board = {
      'current_sign': 'X'
    }
    board_fields = []
    (0..(BOARD_SIZE - 1)).each do |x|
      board_fields[x] = []
      (0..(BOARD_SIZE - 1)).each do |y|
        board_fields[x][y] = nil
      end
    end
    self.board['board_fields'] = board_fields
    self
  end

  #
  # Make a given player put a mark onto given x,y coordinate,
  # raise error if placement is made into an invalid field
  # #
  def make_move(placement)
    unless can_place?(placement)
      raise ActiveRecord::RecordInvalid.new(self)
    end
    new_board = board
    new_board['board_fields'][placement[1]][placement[0]] = board['current_sign']
    new_board['current_sign'] = board['current_sign'] == 'X' ? 'O' : 'X'
    self.board = new_board
    save!
    self
  end

  #
  # Determines whether player can
  # make a move to given coordinates
  # #
  def can_place?(placement)
    if !board['board_fields'][placement[1]][placement[0]].blank?
      errors.add(:placement, 'Can not be done on the occupied field')
      return false
    end
    true
  end

  #
  # Method that checks winner of the game and updates
  # game status accordingly
  # #
  def check_winner
    winning_tile = (check_horizontal || check_vertical || check_diagonal)
    if winning_tile.blank?
      # p 'Winnner!'
      self.status = 'finished'
    end
  end

  #
  # See whether there is a horizontal winner
  # #
  def check_horizontal
    (0..(BOARD_SIZE - 1)).each do |y|
      all_row_entries = board['board_fields'][y].uniq
      if all_row_entries.length == 1 && !all_row_entries.first.blank?
        # someone won
        return all_row_entries.first
      end
    end
    false
  end

  #
  # See whether there is a vertical winner
  # #
  def check_vertical
    (0..(BOARD_SIZE - 1)).each do |x|
      all_row_entries = board['board_fields'].map { |entry| entry[x] }.uniq
      if all_row_entries.length == 1 && !all_row_entries.first.blank?
        # someone won
        return all_row_entries.first
      end
    end
    false
  end

  #
  # See whether there is a diagonal winner
  # #
  def check_diagonal
    # first diagonal
    all_row_entries = []
    (0..(BOARD_SIZE - 1)).each do |x|
      all_row_entries << board['board_fields'][x][x]
    end
    if all_row_entries.length == 1 && !all_row_entries.first.blank?
      # someone won
      return all_row_entries.first
    end
    # second diagonal
    all_row_entries = []
    (0..(BOARD_SIZE - 1)).each do |x|
      all_row_entries << board['board_fields'][x][BOARD_SIZE - 1 - x]
    end
    if all_row_entries.length == 1 && !all_row_entries.first.blank?
      # someone won
      return all_row_entries.first
    end
    false
  end

  #
  # Display the current state of the board in a
  # form that is understandable to a person.
  # #
  def show_board
    (0..(BOARD_SIZE - 1)).each do |x|
      p self.board['board_fields'][x].map { |sign| sign ? sign : ' ' }.join('|')
    end
    self
  end
end
