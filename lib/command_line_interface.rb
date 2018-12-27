class CommandLineInterface
  attr_accessor :farmer
  def the_prompt(string, array_of_choices)
    prompt = TTY::Prompt.new
    choice = prompt.select(string, array_of_choices)
  end

  def game_start
    # open "./audio/01 - Wonderful Life.mp3"
    # binding.pry
    puts "==========================================="
    puts ""
    puts "Welcome to Harvest Moon: Command Line Town!"
    puts ""
    puts "==========================================="
    puts ""
    opening_menu = ["New Game", "Load Game", "Exit"]
    choice = the_prompt("", opening_menu)
    #choice = choice.parameterize.underscore converts choice to snake_case

    case choice
    when "New Game"
        character_creation
      when "Load Game"
        character_menu
      when "Exit"
        exit_message
    end
  end

  def character_creation
    prompt = TTY::Prompt.new
    farmer_name = prompt.ask("What's your Farmer's name?", required: true)
    self.farmer = Farmer.new( name: farmer_name )
    binding.pry
    puts "You are Farmer #{self.farmer.name}. Welcome!"
    puts ""
    puts "-------------------------------"
    puts ""
    game_menu
  end

  def character_menu
    choice = the_prompt("Choose a File", Farmer.pluck("name"))
    # binding.pry
    self.farmer = Farmer.find_by(name: choice)
    puts "Welcome back, Farmer #{self.farmer.name}!"
    puts ""
    puts "-------------------------------"
    puts ""
    game_menu
  end

  def main_menu_array
    [ "My Farmer", "Field", "Market", "Home", "Exit" ]
  end

  def game_menu
    puts "Name:".colorize(:color => :magenta, :background => :light_white) + " #{farmer.name}"
    choice = the_prompt("MAIN MENU", main_menu_array)
    case choice
    when "My Farmer"
      go_to_status
    when "Field"
      go_to_field
    when "Market"
      go_to_market
    when "Home"
      go_to_home
    when "Exit"
      exit_message
    end
  end

  def go_to_status
    stuff = farmer.seed_bags.pluck("seed_name")
    new_stuff = stuff.each_with_object(Hash.new(0)) do |item, hash|
      hash[item] += 1
      #=> {"turnip"=>2, "radish"=>5}
    end
    puts "==========================================="
    puts ""
    new_stuff.each do |crop, amount_owned|
      puts "#{crop}".upcase.bold
      puts "Bags owned: #{amount_owned}"
      puts "-------------------------------------------"
      puts ""
    end
    puts ""
    puts "==========================================="
    puts ""
    game_menu
  end

  def go_to_field
    # list of planted crops and their watered status
    # new prompt for water, harvest, uproot
  end

  def go_to_market
    choice = the_prompt("MARKETPLACE", ["Buy", "Sell", "Exit"])
    case choice
    when "Buy"
      #list of seeds and prices
      #new prompt selecting from list of seeds to buy
      item = the_prompt("Buy Seed Bag?", ["Yes", "No"])
      case item
      when "Yes"
        new_crop = farmer.buy_seed_bag(SeedBag.first)
        binding.pry
      when "No"
        go_to_market
      end
    when "Sell"
      puts "Not yet, sorry. Come back later!"
      go_to_market
    when "Exit"
      game_menu
    end
  end

  def go_to_home
    #Maybe flavor text of the dog doing various things?
    #Pet Dog, Sleep, Go Back Outside
  end

  def exit_message
    puts "==========================================="
    puts ""
    puts "                Good Bye!"
    puts ""
    puts "==========================================="
    return puts ""
  end
end
