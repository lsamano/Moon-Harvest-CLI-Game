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
    [ "Inventory", "Field", "Market", "Home", "Exit" ]
  end

  def game_menu
    puts "Name:".bold.colorize(:color => :green, :background => :light_white) + " #{farmer.name}"
    choice = the_prompt("MAIN MENU", main_menu_array)
    case choice
    when "Inventory"
      go_to_inventory
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

  def seed_bag_inventory_hash
    stuff = farmer.seed_bags.where("planted = ?", 0).pluck("seed_name")
    stuff.each_with_object(Hash.new(0)) do |seed_bag, hash|
      hash[seed_bag] += 1
      #=> {"turnip"=>2, "radish"=>5}
    end
  end

  def go_to_inventory
    puts "==========================================="
    puts "                INVENTORY"
    puts "==========================================="
    puts ""
    seed_bag_inventory_hash.each do |crop, amount_owned|
      puts "#{crop}".upcase.bold
      puts "Bags owned: #{amount_owned}"
      puts "-------------------------------------------"
      puts ""
    end
    puts "==========================================="
    puts ""
    game_menu
  end

  def field_array
    [ "Plant", "Water", "Harvest", "Destroy", "Exit" ]
  end

  def go_to_field
    puts "==========================================="
    puts "                  FIELD"
    puts "==========================================="
    puts ""

    # list of planted crops and their watered status

    planted_crop_array = farmer.crops.where("planted = ?", 1)
    if planted_crop_array.empty?
      puts "Your field is empty! Why not try planting some seeds?"
    else
      planted_crop_array.each do |crop|
        # binding.pry
        puts "#{crop.seed_bag.seed_name}".upcase.bold
        puts "Days Planted: #{crop.days_planted}"
        if crop.watered?
          puts "Soil: The soil is nice and damp.".colorize(:cyan)
        else
          puts "Soil: The soil is dry.".colorize(:yellow)
        end
        puts "-------------------------------------------"
        puts ""
      end
    end
    # new prompt for plant, water, harvest, destroy
    choice = the_prompt("What would you like to do?", field_array)
    case choice
    when "Plant"
      array_of_unplanted = farmer.crops.where("planted = ?", 0)
      # binding.pry
      unplanted_hash = array_of_unplanted.each_with_object(Hash.new()) do |crop, hash|
        hash[crop.seed_bag.seed_name] = crop
      end
      choice = the_prompt("Which seed would you like to plant?", unplanted_hash)
      confirmation = the_prompt("Are you sure you want to plant #{choice.seed_bag.seed_name}?", ["Yes", "No"])
      if confirmation == "Yes"
        choice.update(planted: 1)
        puts "Planted!"
      end
      go_to_field
    when "Water"
      unwatered_array = farmer.crops.where("planted = ?", 1).where("watered = ?", 0)
      unwatered_hash = unwatered_array.each_with_object(Hash.new()) do |crop, hash|
        hash[crop.seed_bag.seed_name] = crop
      end
      # binding.pry
      # .pluck("seed_name")
      if unwatered_array.empty?
        puts "You have no crops that need to be watered!"
      else
        choice = the_prompt("Which crop would you like to water?", unwatered_hash)
        choice.update(watered: 1)
        puts "Watered!"
      end
      # Find choice and switch its watered stat to true/1
      go_to_field
    when "Harvest"
      puts "Coming soon!"
      go_to_field
    when "Destroy"
      puts "No, never. ):"
      go_to_field
    when "Exit"
      game_menu
    end
  end

  def go_to_market
    puts "==========================================="
    puts "               MARKETPLACE"
    puts "==========================================="
    choice = the_prompt("Vendor: Hello! What would you like to do?", ["Buy", "Sell", "Exit"])
    case choice
    when "Buy"
      #list of seeds and prices
      puts "==========================================="
      puts ""
      SeedBag.all.each do |seed_bag|
        puts "Name:  " + "#{seed_bag.seed_name}".upcase.bold
        puts "Price: " + "#{seed_bag.price}".upcase.bold + " G"
        puts "-------------------------------------------"
        puts ""
      end
      #new prompt selecting from list of seeds to buy
      choice = the_prompt("What would you like to purchase?", SeedBag.pluck("seed_name"))
      chosen_bag = SeedBag.find_by(seed_name: choice)
      confirmation = the_prompt("Buy one bag of #{choice}?", ["Yes", "No"])
      case confirmation
      when "Yes"
        new_crop = farmer.buy_seed_bag(chosen_bag)
        # binding.pry
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
    puts ""
    puts "-------------------------------------------"
    puts ""
    puts "Your dog is quietly snoring on your bed..."
    puts ""
    puts "... But this is no time for resting!"
    puts "* You head back outside. *".italic
    puts ""
    puts "-------------------------------------------"
    puts ""
    game_menu
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
