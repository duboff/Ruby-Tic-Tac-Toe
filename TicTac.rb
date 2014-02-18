#!/usr/bin/env ruby

class Game
    def initialize
        @size = 0 #board size
        @human = nil #human switch
        @no_humans = 0
        @no_turns = 0
        @@score_1 = 0 #keeping score player 1
        @@score_2 = 0 #keeping score player 2
        @end = 0
    end
    
    def main_menu
        #Operates game's Main Menu
        puts ''
        puts "Welcome to Tic Tac Toe"
        puts ''
        mode_choice
        puts ''
        size_choice
        player_choice
        loop do
            new_board #clean up the board for new game
            play_a_game #play the game
            display_score 
            play_another #ask user if they want to play another one
            if @end == true
                break
            end
        end
        puts ''
    end
    
    def new_board
        #creates new board of a given size
        @board = Array.new(@size) { Array.new(@size,'_') }
        @no_turns = 0
        @win_seq_x = Array.new(@size, 'X') #winning sequence for checking later
        @win_seq_o = Array.new(@size, 'O') #winning sequence for checking later
    end 
    
    def draw_board
      # Displays the board in a legible way
        puts ''
        print '   '
        puts (1..@size).to_a.join('  ') #printing column indices
        (0...@size).each do |x|
          (0...@size).each do |y|
            print "#{x+1} " if y==0 #printing row indices
            print " #{@board[x][y]} " #printing cells themselves looping through the board
          end
            puts ""
        end
        puts ''
    end
    
    def display_score
      #Displays scores at any point during the game
      puts ''
      puts "Score:"
      puts "X: #{@@score_1}"
      puts "O: #{@@score_2}"
    end
    
    def size_choice
      #Asks user to choose the size of the board
      loop do #loop to make sure size choice is corect
        puts "Please choose the size of the board you would like to play on. Allowed sizes are 3 to 9"
        @size = gets.chomp.to_i
        @win_size = [@size, 5].min #determines how many in a row you need to get to win
        if (3..9).include?(@size)
          #lower than 3 no point playing. Above 9 takes too long.
          puts ''
          puts " :: On this board you need to get #{@win_size} in a row to win :: "
          puts ''
          break
        else
          puts "Wrong input. Please try again"
        end
      end
    end
    
    def mode_choice
      #choosing the number of players
      loop do
        puts '==========================='
        puts "Enter 1 for Single Player Mode and 2 for Multiplayer mode"
        @no_humans = gets.chomp.to_i
        if (1..2).include?(@no_humans)
          break
        else
          puts ""
          puts "Wrong input. Input must be 1 or 2. Please try again"
        end
      end
    end
    
    def play_another
        #Asks user if they want to play another game
        puts ''
        loop do
            puts "Do you want to play another game? Enter 'y' to play or 'n' to quit"
            input = gets.chomp.downcase
            if input == 'y'
                break
            elsif input == 'n'
                puts ''
                puts "Thanks for playing!"
                @end = true
                break
            else
                puts "Wrong input. Please try again"
            end
        end
    end
   
    def find(a,b)
      # Helper function for check_win. Searches one array (b) within another (a). 
      # Takes two arrays as args
      if a == nil
        return false
      elsif a[0...b.length] == b
        return true
      else
        return find(a[1..a.length],b)
      end
    end

    def check_win
      #Checking if thewre is a winning sequence on the board
        count = 0 #count for number of winning sequences
        diag_1 = (0...@size).collect { |i| @board[i][i] } #getting the board's diagonal as an array
        diag_2 = (0...@size).collect { |i| @board.reverse[i][i] } #getting the board's 2nd diagonal as an array
        to_check = [diag_1, diag_2] #creating array of where to look for winning positions
        (0...@size).each do |x|
          #adding all rows and cols to the checking array
            to_check.push(@board[x])
            to_check.push(@board.transpose[x])
        end
        to_check.each { |x| count += 1 if find(x, @win_seq_x) || find(x, @win_seq_o) }
        #checking if the checking array contains at least 1 winning sequence
        return count > 0
    end
    
    def game_over(a)
      #displays Game Over message when required
        puts ''
        puts '************************'
        puts "== Game Over. #{a} won =="
        puts '************************'
        finish = true
    end

    def player_choice
      #Player choice of X or O
        if @no_humans == 1
            loop do
                puts "Who would you rather be O or X. Type 'X' or 'O'"
                input = gets.chomp.downcase
                if input == "x"
                    @human = 0
                    break
                elsif input == "o"
                    @human = 1
                    break
                else
                    puts "Wrong input"
                end
            end
        end
    end
 
    def human_turn(player)
      #one human turn. Asks human to select a cell and warns if the cell is already occupied
        turn_finished = false
        mark = "O" if player == 1
        mark = "X" if player == 0
        while turn_finished == false
            choice_x = ''
            choice_y = ''
            loop do
                puts ''
                puts ":: Your turn player #{player+1} ::"
                puts ''
                puts "Please choose row for #{mark}. Row should be between 1 and #{@size}"
                choice_x = gets.chomp.to_i - 1
                break if (0..@size).include?(choice_x)
                puts "Illegal input"
                puts ''
            end
            while (true)
                puts ''
                puts "Please choose column for #{mark}. C should be between 1 and #{@size}"
                choice_y = gets.chomp.to_i - 1
                if (0..@size).include?(choice_y)
                    break
                else
                    puts "Illegal input"
                    puts ''
                end
            end
            if @board[choice_x][choice_y] == '_'
                @board[choice_x][choice_y] = mark
                @no_turns += 1
                turn_finished = true
            else
                puts "This cell is already occupied"
            end
        end
    end
    
    def computer_turn(player)
      #Computer turn. Computer selects cells randomly until it finds an empty one.
        puts ''
        puts ":: Computer's turn ::"
        comp_fin = false
        mark = "O" if player == 1
        mark = "X" if player == 0
        while comp_fin == false
            row = rand(@size)
            col = rand(@size) 
            if @board[row][col] == '_'
                @board[row][col] = mark
                @no_turns += 1
                comp_fin = true
            end
        end
    end
    
    def play_a_game
      #single game sequence
    finish = false
    while finish == false
        draw_board
        if @no_humans == 2
          #multiplayer mode. Human turn 1, then human turn 2 until there is a win or a draw.
            human_turn(0)
            draw_board
            if check_win
                game_over('X')
                @@score_1 += 1
                break
            end
            if @no_turns == @size ** 2
              #draw  if there is no win and it's the last move on the board (always the square of the size)
                puts "== It's a draw! =="
                finish == true
                break
            end
            human_turn(1)
        else
          #single player mode
            if @human == 0
              #if human plays X. Human goes first
                human_turn(0)
                draw_board
                #checking for win
                if check_win
                    game_over('X')
                    @@score_1 += 1
                    break
                end
                #checking for draw
                if @no_turns == @size ** 2
                    puts " == It's a draw! =="
                    finish == true
                    break
                end
                computer_turn(1)
            elsif @human == 1
              #if human plays O. Computer goes first
                computer_turn(0)
                draw_board
                if check_win
                    game_over('X')
                    @@score_1 += 1
                    break
                end
                if @no_turns == @size ** 2
                    puts "== It's a draw! =="
                    finish == true
                    break
                end
                human_turn(1)
            end
        end
        if check_win
          #checking for win after the second turn ('O')
            draw_board
            game_over('O')
            @@score_2 += 1
            break
        end
        if @no_turns == @size ** 2
            puts "It's a draw!"
            finish == true
            break
        end
    end
  end 
end

#launching the game
Game.new.main_menu