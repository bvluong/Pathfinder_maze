class Maze
  attr_reader :maze

  def initialize(maze)
    @maze = maze
    @current_position = find_start_point
    @start_position = find_start_point
    @end_position = find_end_point
    @moves_hash = Hash.new
    @moves = [method(:move_up),method(:move_right),method(:move_down),method(:move_left)]
  end

  def update_moves_hash(parent)
    @moves.each do |x|
      if possible_move?(x.call(parent)) and !@moves_hash.include? x.call(parent)
        @moves_hash[x.call(parent)] = parent
      end
    end
  end

  def fill_moves_hash
    until @moves_hash.keys.include? @end_position
      @moves_hash.keys.each {|x| update_moves_hash(x) }
    end
  end

  def [](pos)
    row,col = pos
    @maze[row][col]
  end

  def []=(pos,val)
    row,col = pos
    @maze[row][col] = val
  end

  def find_end_point
    @maze.each_index do |x|
      @maze[x].each_index { |y| return [x,y] if @maze[x][y] == "E" }
    end
  end

  def find_start_point
    @maze.each_index do |x|
      @maze[x].each_index { |y| return [x,y] if @maze[x][y] == "S" }
    end
  end

  def possible_move?(pos)
    self[pos] == " " or self[pos] == "E" or self[pos] == "S"
  end

  def place_mark(pos,val)
    self[pos] = val
  end

  def move_up(pos)
    [pos[0]-1,pos[1]]
  end

  def move_down(pos)
    [pos[0]+1,pos[1]]
  end

  def move_right(pos)
    [pos[0],pos[1]+1]
  end

  def move_left(pos)
    [pos[0],pos[1]-1]
  end

  def game_over?
    @moves.each { |x| return true if self[x.call(@start_position)] == "X" }
    false
  end

  def display
    y = @maze.map {|x| x.join("")}
    y.each.with_index {|a,b| p "#{b} #{a}"}
  end

  def find_move(parent)
    @moves_hash[parent]
  end

  def play_turn
    nextmove = find_move(@current_position)
    place_mark(nextmove,"X")
    @current_position = nextmove
  end

  def setup
    @moves_hash[@current_position] = @current_position
    fill_moves_hash
    @current_position = @end_position
    until game_over?
      play_turn
      display
    end
  end

end


input = $stdin.read
maze = Array.new
input.split("\n").each do |x|
  maze << x.split("")
end


if __FILE__ == $PROGRAM_NAME
  newgame = Maze.new(maze)
  newgame.setup
end
