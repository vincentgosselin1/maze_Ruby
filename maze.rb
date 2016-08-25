#maze.rb by Vincent Gosselin, 2016.

class Position
	attr_accessor :x, :y, :links_to 
	def initialize(position)
		@x = position[0]
		@y = position[1]
		@links_to = what_is_around(position)
	end
	def what_is_around(position)
		@x = position[0]
		@y = position[1]

		#Start position is [1,1]
		#There is a delimiter on every side of the maze that is '#'.

		#positions_next_to returns 4 arrays of coordinates 
		#that links every position to each others.
		positions_next_to(position)
	end

	def location
		[@x, @y]
	end

	private

	def positions_next_to(position)
		returning_arrays = [:north,:south,:west,:east]

		#return position that are north, south, west, east. from a center point.

		#first -> north to position means [x,y] -> [x, y-1]
		x = position[0] #same
		y = position[1] - 1 
		first = [x,y]
		#input into returning_arrays
		returning_arrays[0] = first

		#second -> south to position means [x,y] -> [x,y+1]
		x = position[0] #same
		y = position[1] + 1 
		second = [x,y]
		#input into returning_arrays
		returning_arrays[1] = second

		#third -> west to position means [x,y] -> [x-1,y]
		x = position[0] - 1
		y = position[1] #same 
		third = [x,y]
		#input into returning_arrays
		returning_arrays[2] = third

		#fourth -> east to position means [x,y] -> [x+1,y]
		x = position[0] + 1
		y = position[1] #same 
		fourth = [x,y]
		#input into returning_arrays
		returning_arrays[3] = fourth

		return returning_arrays

	end
end


class Maze
	attr_accessor :level, :grid, :player

	def initialize(level)
		@level = level
		@grid = []
		build_maze(1)
	end

	def build_maze(level)
		case level
		when 1
			#Maze 6 x 5 Being Created here is the map.

			######             s -> start
			#s#### 			   # -> block
			#.#### 			   . -> tile
			#...f# 			   f -> finish
			######

			#open the file containing maze.
			lines = File.readlines('level1.txt')

			#lines looks like :
			# => ["######\n", "#p####\n", "#.##f#\n", "#....#\n", "######"]

			
			#let's remove \n from every row and and 
			lines.each {|row| row.gsub!(/\n/,'')}

			#let's build the grid of the maze with tiles and block from the lines
			builder(lines)
		end
	end

	def player_start
		@grid.each do |element|
		 if element.class.to_s == "Maze::Start"
		 	@player = Player.new([element.x,element.y])
		 	end 
		end
	end

	def return_element(position)
		@grid.each do |element| 
			if element.location == position
				return element 
			end
		end
	end

	#returns 1 array of 4 elements like this one, 
	#<Maze::Block:0x007fdfabb01c50 @x=2, @y=4, @links_to=[[2, 3], [2, 5], [1, 4], [3, 4]]>
	def return_surroundings(position)
		returning_array = []
		#return element at position
		element = return_element(position)
		
		#For each link to a position, find it's object in the grid.
		0.upto(3) do |index|
		element_from_grid = return_element(element.links_to[index]) 
		returning_array << element_from_grid
		end
		return returning_array
	end

	def player_move(input)
		location = player.location
		case input
		when "w"
			player.y -= 1 if can_move?("w")
		when "s"
			player.y += 1 if can_move?("s") 
		when "a"
			player.x -= 1 if can_move?("a")
		when "d"
			player.x += 1 if can_move?("d")
		end
	end

	def can_move?(input)
		case input
		when "w"
			i = player.location[0]
			j = player.location[1] - 1
		when "s"
			i = player.location[0]
			j = player.location[1] + 1
		when "a"
			i = player.location[0] - 1
			j = player.location[1]
		when "d" 
			i = player.location[0] + 1
			j = player.location[1]
		end
		
		direction = [i,j]

		case return_element(direction).class.to_s
		when "Maze::Tile"
			puts "You moved!"
			return true
		when "Maze::Finish"
			puts "You finished the maze!"
			return true
		when "Maze::Start"
			puts "There is a whole on the floor now."
			return false		
		else
			puts "You can't move there."
			return false
		end
	end

		private
		#Builds the grid with tiles and blocks 
		def builder(array)
			#the array looks like ["######", "#s####", "#.##f#", "#....#", "######"]

			#what are maze dimentions?
			columns = array[0].scan(/./).count
			rows = array.size

			#Lets build the grird row by row, column by column. rows => y, columns => x
			0.upto(rows-1) do |y|
				0.upto(columns-1) do |x|
					#current position in [x,y]
					position = [x,y]
					#scan every element of the array
					element = array[y].scan(/./)

					case element[x]
					when "#"
						@grid << Block.new(position)
					when "."
						@grid << Tile.new(position)
					when "s"
						@grid << Start.new(position)
					when "f"
						@grid << Finish.new(position)
					end
				end
			end
		end


class Tile < Position
end

class Block < Position
end

class Start < Position
end

class Finish < Position
end

class Player < Position

	def show_position
		return [x, y]
	end

end

end



welcome = %{
	Select a level you want to do:
	level 1 -> press 1 + enter
	level 2 -> press 2 + enter
	level 3 -> press 3 + enter"
	}

puts welcome
level = gets.chop

maze = Maze.new(level)
player = maze.player_start
puts "welcome in the Dungeon! All you have is this map:"
puts File.readlines('level1.txt')
puts "you can go w, s, a, d"
while 1
	input = gets.chop
	maze.player_move(input)
end






