class Maze
  attr_reader :maze
  
  def initialize(maze)
    @maze = maze
    @current_position = find_start_point
    @start_position = find_start_point
    @end_position = find_end_point
    @moves_hash = Hash.new
    @distance_hash = Hash.new
    @moves = [method(:move_up),method(:move_right),method(:move_down),method(:move_left)]
    @allpossiblemoves = allpossiblemoves
  end
  
  def update_moves_hash(parent)
    possiblemoves = Array.new
    @moves.each do |x|
      nextmove = x.call(parent)
      possiblemoves << nextmove if possible_move?(nextmove)
    @moves_hash[parent] = possiblemoves
    end
  end
  
  def fill_moves_hash
    count = 0
    until @allpossiblemoves.count+1 == @moves_hash.keys.count
      @moves_hash.values.each do |y| 
        y.each {|x| update_moves_hash(x) if !@moves_hash.keys.include? y}
        y.each {|x| update_distance(x,count) }
      end
    count += 1
    end
  end
  
  def update_distance(pos,count)
    @distance_hash[pos] = count if @distance_hash[pos] == nil
  end
  
  def allpossiblemoves
    list = Array.new
    @maze.each_index do |x|
     @maze[x].each_index { |y| list << [x,y] if @maze[x][y] == " " }
    end
    list
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
  
  def find_shortest(arr)
    distance = 999
    move = Array.new
    arr.each {|x| move,distance = x, @distance_hash[x] if @distance_hash[x] < distance}
    move
  end

  def find_move(parent)
    moves= Array.new
    @moves_hash.each { |x,y| moves << x if y.include? parent} 
    find_shortest(moves)
  end
  
  def play_turn
    nextmove = find_move(@current_position)
    place_mark(nextmove,"X")
    @current_position = nextmove
  end
  
  def setup
    update_moves_hash(@current_position)
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
