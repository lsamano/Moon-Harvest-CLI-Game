class CommandLineInterface

  def game_start
    # open "./audio/01 - Wonderful Life.mp3"
    # binding.pry
    puts "==========================================="
    puts ""
    puts "Welcome to Harvest Moon: Command Line Town!"
    puts ""
    puts "==========================================="
    puts ""

    prompt = TTY::Prompt.new
    choice = prompt.select("", ["New Game", "Load Game", "Exit"])
    choice = choice.parameterize.underscore #converts choice to snake_case

    case choice
      when "new_game"
        character_creation
      when "load_game"
        character_menu
      when "exit"
        return puts "Good Bye!"
    end
  end

  def character_creation
    prompt = TTY::Prompt.new
    farmer_name = prompt.ask("What's your Farmer's name?", required: true)
    # binding.pry
    # puts  "What is your Farmer's name?"
    # farmer_name = gets.chomp
    #
    farmer = Farmer.new(
      name: farmer_name
    )

    puts "You are Farmer #{farmer.name}. Welcome!"
    puts ""
    puts "-------------------------------"
    puts ""
    #needs to run main game menu start up
  end

  def character_menu
    array_of_farmer_names = Farmer.all.map{ |farmer| farmer.name}
    prompt = TTY::Prompt.new
    choice = prompt.select("Choose a File", array_of_farmer_names)
     # binding.pry
    farmer = Farmer.find_by(name: choice)
    puts "Welcome back, Farmer #{farmer.name}!"
    puts ""
    puts "-------------------------------"
    puts ""
    #needs to run main game menu start up
  end
end
