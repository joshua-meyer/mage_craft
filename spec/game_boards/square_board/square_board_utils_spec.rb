square_board_path = File.expand_path("../../../../lib/game_boards/square_board.rb", __FILE__)
require square_board_path

include Base

describe SquareGameBoard do
  let(:board_1) { SquareGameBoard.new(1) }
  let(:board_2) { SquareGameBoard.new(2) }
  let(:board_5) { SquareGameBoard.new(5) }

  BOARD_TWO_WITH_TEST_AT_1_1 = [
    [SquareGameBoard::BLANK_SPACE, SquareGameBoard::BLANK_SPACE],
    [SquareGameBoard::BLANK_SPACE, "test"]
  ]

  context "spot checks" do

    it "set_location_of_piece" do
      board_2.set_location_of_piece([1, 1], "test")
      expect(board_2.game_board).to eq(BOARD_TWO_WITH_TEST_AT_1_1)
    end

    it "fetch_location" do
      board_2.set_location_of_piece([0, 1], "test")
      expect(board_2.fetch_location([0, 0])).to eq(SquareGameBoard::BLANK_SPACE)
      expect(board_2.fetch_location([0, 1])).to eq("test")
    end

    it "location_of_piece" do
      board_2.set_location_of_piece([1, 0], "test")
      expect(board_2.location_of_piece("test")).to eq([1,0])
      expect(board_2.location_of_piece("another_test")).to eq(nil)
    end

    it "is_valid_location?" do
      expect(board_2.is_valid_location?([0, 0])).to be true
      expect(board_2.is_valid_location?([1, 1])).to be true
      expect(board_2.is_valid_location?([-1, 0])).to be false
      expect(board_2.is_valid_location?([0, 2])).to be false
      expect(board_2.is_valid_location?([0, 0, 0])).to be false
      expect(board_2.is_valid_location?({0 => 0})).to be false
      expect(board_2.is_valid_location?([0])).to be false
    end

    it "distance_between_2_valid_locations" do
      expect(board_5.distance_between_2_valid_locations([1, 2], [1, 2])).to eq(0)

      expect(board_5.distance_between_2_valid_locations([1, 2], [2, 2])).to eq(1)
      expect(board_5.distance_between_2_valid_locations([2, 2], [1, 2])).to eq(1)
      expect(board_5.distance_between_2_valid_locations([2, 1], [2, 2])).to eq(1)
      expect(board_5.distance_between_2_valid_locations([2, 2], [2, 1])).to eq(1)

      expect(board_5.distance_between_2_valid_locations([1, 2], [2, 3])).to eq(2)
      expect(board_5.distance_between_2_valid_locations([2, 3], [1, 2])).to eq(2)
      expect(board_5.distance_between_2_valid_locations([2, 3], [3, 2])).to eq(2)
      expect(board_5.distance_between_2_valid_locations([3, 2], [2, 3])).to eq(2)
      expect(board_5.distance_between_2_valid_locations([1, 2], [3, 2])).to eq(2)
      expect(board_5.distance_between_2_valid_locations([3, 2], [1, 2])).to eq(2)
      expect(board_5.distance_between_2_valid_locations([0, 0], [0, 2])).to eq(2)
      expect(board_5.distance_between_2_valid_locations([0, 2], [0, 0])).to eq(2)
    end

    it "are_2_valid_locations_adjacent" do
      expect(board_2.are_2_valid_locations_adjacent([0, 0], [0, 0])).to be false
      expect(board_2.are_2_valid_locations_adjacent([0, 0], [0, 1])).to be true
      expect(board_2.are_2_valid_locations_adjacent([0, 0], [1, 1])).to be false
    end

    it "vector_between_valid_locations" do
      expect(board_5.vector_between_valid_locations([1, 2], [1, 2])).to eq([0, 0])

      expect(board_5.vector_between_valid_locations([1, 2], [2, 2])).to eq([1, 0])
      expect(board_5.vector_between_valid_locations([2, 2], [1, 2])).to eq([-1, 0])
      expect(board_5.vector_between_valid_locations([2, 1], [2, 2])).to eq([0, 1])
      expect(board_5.vector_between_valid_locations([2, 2], [2, 1])).to eq([0, -1])

      expect(board_5.vector_between_valid_locations([1, 2], [2, 3])).to eq([1, 1])
      expect(board_5.vector_between_valid_locations([2, 3], [1, 2])).to eq([-1, -1])
      expect(board_5.vector_between_valid_locations([2, 3], [3, 2])).to eq([1, -1])
      expect(board_5.vector_between_valid_locations([3, 2], [2, 3])).to eq([-1, 1])
      expect(board_5.vector_between_valid_locations([1, 2], [3, 2])).to eq([2, 0])
      expect(board_5.vector_between_valid_locations([3, 2], [1, 2])).to eq([-2, 0])
      expect(board_5.vector_between_valid_locations([0, 0], [0, 2])).to eq([0, 2])
      expect(board_5.vector_between_valid_locations([0, 2], [0, 0])).to eq([0, -2])
    end

    it "apply_vector_to_valid_position" do
      expect(board_5.apply_vector_to_valid_position([0, 0], [0, 0])).to eq([0, 0])

      expect(board_5.apply_vector_to_valid_position([1, 0], [1, 1])).to eq([2, 1])
      expect(board_5.apply_vector_to_valid_position([-1, 0], [1, 1])).to eq([0, 1])
      expect(board_5.apply_vector_to_valid_position([0, 1], [1, 1])).to eq([1, 2])
      expect(board_5.apply_vector_to_valid_position([0, -1], [1, 1])).to eq([1, 0])

      expect(board_5.apply_vector_to_valid_position([2, 0], [2, 2])).to eq([4, 2])
      expect(board_5.apply_vector_to_valid_position([1, 1], [2, 2])).to eq([3, 3])
      expect(board_5.apply_vector_to_valid_position([1, -1], [2, 2])).to eq([3, 1])
      expect(board_5.apply_vector_to_valid_position([0, 2], [2, 2])).to eq([2, 4])
      expect(board_5.apply_vector_to_valid_position([0, -2], [2, 2])).to eq([2, 0])
      expect(board_5.apply_vector_to_valid_position([-1, 1], [2, 2])).to eq([1, 3])
      expect(board_5.apply_vector_to_valid_position([-1, -1], [2, 2])).to eq([1, 1])
      expect(board_5.apply_vector_to_valid_position([-2, 0], [2, 2])).to eq([0, 2])
    end

    it "map_keyboard_keys_to_adjacent_positions" do
      expect(board_5.map_keyboard_keys_to_adjacent_positions([1, 1])).to eq({ "w" => [0, 1], "a" => [1, 0], "s" => [2, 1], "d" => [1, 2] })
    end

    it "rotate_positive" do
      expect(board_5.rotate_positive([0, 0])).to eq([0, 0])

      expect(board_5.rotate_positive([1, 0])).to eq([0, -1])
      expect(board_5.rotate_positive([0, 1])).to eq([1, 0])
      expect(board_5.rotate_positive([-1, 0])).to eq([0, 1])
      expect(board_5.rotate_positive([0, -1])).to eq([-1, 0])

      expect(board_5.rotate_positive([2, 0])).to eq([0, -2])
      expect(board_5.rotate_positive([1, 1])).to eq([1, -1])
      expect(board_5.rotate_positive([0, 2])).to eq([2, 0])
      expect(board_5.rotate_positive([-1, 1])).to eq([1, 1])
      expect(board_5.rotate_positive([-2, 0])).to eq([0, 2])
      expect(board_5.rotate_positive([-1, -1])).to eq([-1, 1])
      expect(board_5.rotate_positive([0, -2])).to eq([-2, 0])
      expect(board_5.rotate_positive([1, -1])).to eq([-1, -1])
    end

    it "rotate_negative" do
      expect(board_5.rotate_negative([0, 0])).to eq([0, 0])

      expect(board_5.rotate_negative([1, 0])).to eq([0, 1])
      expect(board_5.rotate_negative([0, 1])).to eq([-1, 0])
      expect(board_5.rotate_negative([-1, 0])).to eq([0, -1])
      expect(board_5.rotate_negative([0, -1])).to eq([1, 0])

      expect(board_5.rotate_negative([2, 0])).to eq([0, 2])
      expect(board_5.rotate_negative([1, 1])).to eq([-1, 1])
      expect(board_5.rotate_negative([0, 2])).to eq([-2, 0])
      expect(board_5.rotate_negative([-1, 1])).to eq([-1, -1])
      expect(board_5.rotate_negative([-2, 0])).to eq([0, -2])
      expect(board_5.rotate_negative([-1, -1])).to eq([1, -1])
      expect(board_5.rotate_negative([0, -2])).to eq([2, 0])
      expect(board_5.rotate_negative([1, -1])).to eq([1, 1])
    end

    it "err_unless_vector_is_unit_vector" do
      expect{ board_1.err_unless_vector_is_unit_vector([0,0]) }.to raise_error

      board_1.err_unless_vector_is_unit_vector([0,-1])
      board_1.err_unless_vector_is_unit_vector([0,1])
      board_1.err_unless_vector_is_unit_vector([-1,0])
      board_1.err_unless_vector_is_unit_vector([1,0])

      expect{ board_1.err_unless_vector_is_unit_vector([2,0]) }.to raise_error
      expect{ board_1.err_unless_vector_is_unit_vector([1,1]) }.to raise_error
      expect{ board_1.err_unless_vector_is_unit_vector([1,-1]) }.to raise_error
      expect{ board_1.err_unless_vector_is_unit_vector([0,2]) }.to raise_error
      expect{ board_1.err_unless_vector_is_unit_vector([0,-2]) }.to raise_error
      expect{ board_1.err_unless_vector_is_unit_vector([-1,1]) }.to raise_error
      expect{ board_1.err_unless_vector_is_unit_vector([-1,-1]) }.to raise_error
      expect{ board_1.err_unless_vector_is_unit_vector([-2,0]) }.to raise_error
    end

  end

  context "map_keyboard_keys_to_adjacent_positions" do

    it "should be adjacent, or off the board" do
      board_5.game_board.each_with_index do |row, row_number|
        row.each_index do |column_number|
          location = [row_number, column_number]
          mapped_positions = board_5.map_keyboard_keys_to_adjacent_positions(location).values
          mapped_positions.each do |p|
            t = !board_5.is_valid_location?(p) || board_5.are_2_valid_locations_adjacent(location, p)
            expect(t).to be true
          end
        end
      end
    end

  end

end
