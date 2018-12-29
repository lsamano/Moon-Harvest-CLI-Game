class CommandLineInterface
  attr_accessor :farmer
  def select_prompt(string, array_of_choices)
    prompt = TTY::Prompt.new
    prompt.select(string, array_of_choices)
  end
  def naming_prompt(string)
    prompt = TTY::Prompt.new
    prompt.ask(string, required: true)
  end
  def seed_bag_hash
    array = yield
    unwatered_hash = array.each_with_object(Hash.new()) do |seed_bag, hash|
      hash[seed_bag.crop_type.crop_name] = seed_bag
    end
  end


  def game_start
    # open "./audio/01 - Wonderful Life.mp3"
    puts "==========================================="
    puts ""
    puts "Welcome to Harvest Moon: Command Line Town!"
    puts ""
    puts "==========================================="
    puts ""
    opening_menu = ["New Game", "Load Game", "Exit"]
    choice = select_prompt("", opening_menu)
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
    farmer_name = naming_prompt("What's your Farmer's name?")
    self.farmer = Farmer.new(
      name: farmer_name,
      day: 1,
      season: "fall",
      money: 5000
    )
    binding.pry
    puts "You are Farmer #{self.farmer.name}. Welcome!"
    puts ""
    puts "-------------------------------"
    puts ""
    # prompt = TTY::Prompt.new
    # dog_name = prompt.ask("What is your dog's name?", required: true)
    # self.farmer = Farmer.new( name: farmer_name )
    game_menu
  end

  def character_menu
    choice = select_prompt("Choose a File", Farmer.pluck("name"))
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
    puts "Farmer #{farmer.name}".bold.colorize(:color => :black, :background => :light_white)
    puts "🌖 Day #{farmer.day}"
    puts "💰 #{farmer.money} G"
    choice = select_prompt("MAIN MENU", main_menu_array)
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
    seed_name_array = farmer.crop_types.where("planted = ?", 0).where("harvested = ?", 0).pluck("crop_name")
    seed_name_array.each_with_object(Hash.new(0)) do |crop_name, inv_hash|
      inv_hash[crop_name] += 1
      #=> {"turnip"=>2, "radish"=>5}
    end
  end

  def ripe_seed_inventory_hash
    seed_name_array = farmer.crop_types.where("planted = ?", 0).where("harvested = ?", 1).pluck("crop_name")
    seed_name_array.each_with_object(Hash.new(0)) do |crop_name, inv_hash|
      inv_hash[crop_name] += 1
    end
  end

  def go_to_inventory
    puts "==========================================="
    puts "                INVENTORY"
    puts "==========================================="
    puts ""
    puts "SEED BAGS".colorize(:yellow)
    seed_bag_inventory_hash.each do |crop, amount_owned|
      puts "#{crop}".upcase.bold
      puts "Bags owned: #{amount_owned}"
      puts "-------------------------------------------"
    end
    puts ""
    puts "HARVESTED CROPS".colorize(:light_green)
    ripe_seed_inventory_hash.each do |crop, amount_owned|
      puts "#{crop}".upcase.bold
      puts "Amount: #{amount_owned}"
      puts "-------------------------------------------"
    end
    puts ""
    game_menu
  end

  def field_array
    [ "Plant", "Water", "Harvest", "Destroy", "Exit" ]
  end

  # list of planted crops and their watered status
  def print_planted_seeds
    planted_seed_array = farmer.seed_bags.where("planted = ?", 1)
    if planted_seed_array.empty?
      puts "Your field is empty! Why not try planting some seeds?"
    else
      planted_seed_array.each do |seed_bag|
        puts "#{seed_bag.crop_type.crop_name}".upcase.bold
        puts "Growth: #{(seed_bag.growth/seed_bag.crop_type.days_to_grow.to_f*100).round(1)}%"
        if seed_bag.ripe?
          puts "Soil: This crop is ready to be harvest!".colorize(:light_green)
        elsif seed_bag.watered?
          puts "Soil: The soil is nice and damp.".colorize(:cyan)
        else
          puts "Soil: The soil is dry.".colorize(:yellow)
        end
        puts "-------------------------------------------"
      end
      puts ""
    end
  end

  def go_to_field
    puts "==========================================="
    puts "                  FIELD"
    puts "==========================================="
    puts ""
    print_planted_seeds

    # new prompt for plant, water, harvest, destroy
    choice = select_prompt("What would you like to do?", field_array)
    case choice
    when "Plant"
      array_of_unplanted = farmer.seed_bags.where("planted = ?", 0).where("harvested = ?", 0)
      unplanted_hash = array_of_unplanted.each_with_object(Hash.new()) do |seed_bag, hash|
        hash[seed_bag.crop_type.crop_name] = seed_bag
      end

      # puts brief inventory list of seed bags
      puts "SEED BAGS IN INVENTORY"
      seed_bag_inventory_hash.each do |crop_name, amount|
        puts "#{crop_name}".upcase.bold + " x#{amount}"
      end

      choice = select_prompt("Which seed would you like to plant?", unplanted_hash)
      confirmation = select_prompt("Are you sure you want to plant #{choice.crop_type.crop_name}?", ["Yes", "No"])
      if confirmation == "Yes"
        choice.update(planted: 1)
        puts "Planted!"
      end
      go_to_field
    when "Water"
      unwatered_hash = seed_bag_hash{farmer.seed_bags.where("planted = ?", 1).where("watered = ?", 0).where("ripe = ?", 0)}
      if unwatered_hash.empty?
        puts "You have no crops that need to be watered!"
      else
        choice = select_prompt("Which crop would you like to water?", unwatered_hash)
        choice.update(watered: 1)
        puts "Watered!"
      end
      go_to_field
    when "Harvest"
      ripe_hash = seed_bag_hash{farmer.seed_bags.where("ripe = ?", 1).where("planted = ?", 1)}
      if ripe_hash.empty?
        puts "You have no crops you can harvest right now!"
      else
        choice = select_prompt("What would you like to harvest?", ripe_hash)
        choice.update(harvested: 1)
        choice.update(planted: 0)
      end
      go_to_field
    when "Destroy"
      planted_array = farmer.seed_bags.where("planted = ?", 1)

      if planted_array.empty?
        puts "There's nothing in your field to destroy!"
        go_to_field
      else
        #puts brief numbered list of field crops
        planted_array.each_with_index do |planted_seed_bag, index|
          puts "#{index+1}. #{planted_seed_bag.crop_type.crop_name}     Growth: #{(planted_seed_bag.growth/planted_seed_bag.crop_type.days_to_grow.to_f*100).round(1)}%"
        end
        # numbers_array = (1..planted_array.count).to_a.map!{|i| i.to_s}
        numbered_hash = planted_array.each_with_object({}).with_index{ |(seed_bag, hash), index| hash["#{index+1}. #{seed_bag.crop_type.crop_name}"] = seed_bag}
        # binding.pry
        choice = select_prompt("What would you like to destroy?", numbered_hash)
        # selected = planted_array[choice.to_i - 1]
        puts "-------------------------------------------"
        puts ""
        puts "This crop?"
        puts ""
        puts "#{choice.crop_type.crop_name}".upcase.bold
        puts "Growth: #{(choice.growth/choice.crop_type.days_to_grow.to_f*100).round(1)}%"
        puts ""
        confirmation = select_prompt("Are you absolutely sure you want to destroy your #{choice.crop_type.crop_name}?\nWARNING: This CANNOT be undone!", ["Destroy it!", "Nevermind"])
        case confirmation
        when "Destroy it!"
          choice.destroy
          puts "The crop was destroyed..."
          go_to_field
        when "Nevermind"
          go_to_field
        end
      end
    when "Exit"
      game_menu
    end
  end

  def go_to_market
    puts "==========================================="
    puts "               MARKETPLACE"
    puts "==========================================="
    choice = select_prompt("Vendor: Hello! What would you like to do?", ["Buy", "Sell", "Exit"])
    case choice
    when "Buy"
      #list of seeds and prices
      puts "==========================================="
      puts ""
      CropType.all.each do |crop_type|
        puts "Name:  " + "#{crop_type.crop_name}".upcase.bold
        puts "buy_price: " + "#{crop_type.buy_price}".upcase.bold + " G"
        puts "-------------------------------------------"
        puts ""
      end
      #new prompt selecting from list of seeds to buy
      choice = select_prompt("What would you like to purchase?", CropType.pluck("crop_name"))
      chosen_bag = CropType.find_by(crop_name: choice)
      confirmation = select_prompt("Buy one bag of #{choice}?", ["Yes", "No"])
      case confirmation
      when "Yes"
        new_crop = farmer.buy_seed_bag(chosen_bag)
        go_to_market
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

  def home_array
    [ "Sleep", "Rename...", "Go Outside" ]
  end

  def go_to_home
    puts "==========================================="
    puts "                 MY HOME"
    puts "==========================================="
    puts ""
    puts "Your dog is quietly snoring on your bed..."
    puts ""
    puts "... But this is no time for resting!"
    puts "* You head back outside. *".italic
    puts ""
    puts "-------------------------------------------"
    puts ""

    choice = select_prompt("What would you like to do?", home_array)
    case choice
    when "Sleep"
      farmer.increment!(:day)
      planted_seed_array = farmer.seed_bags.where("planted = ?", 1)
      planted_seed_array.each do |seed_bag|
        if seed_bag.watered == 1
          seed_bag.increment!(:growth)
          seed_bag.update(watered: 0)
        end
        if seed_bag.growth >= seed_bag.crop_type.days_to_grow
          seed_bag.update(ripe: 1)
        end
      end
      game_menu
    when "Rename..."
      choice = select_prompt("Who would you like to rename?", ["#{farmer.name}", "#{farmer.dog}", "Nevermind"])
      case choice
      when "#{farmer.name}"
        new_name = naming_prompt("What is my new name?")
        farmer.update(name: new_name)
        game_menu
      when "#{farmer.dog}"
        new_name = naming_prompt("What is your dog's new name?")
        farmer.update(dog: new_name)
        game_menu
      when "Nevermind"
        go_to_home
      end
    when "Go Outside"
      game_menu
    end
    #Maybe flavor text of the dog doing various things?
    #Pet Dog, Sleep, Go Outside
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
