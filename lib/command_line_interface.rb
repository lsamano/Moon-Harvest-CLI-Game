class CommandLineInterface
  attr_accessor :farmer, :choice

  # Reusable TTY Prompts
  def select_prompt(string, array_of_choices)
    prompt = TTY::Prompt.new
    prompt.select(string, array_of_choices)
  end
  def naming_prompt(string)
    prompt = TTY::Prompt.new
    prompt.ask(string, required: true)
  end

  # Numbered list of seed bags owned. Yields to the search criteria to narrow
  # what is listed
  def seed_bag_hash
    array = yield
    array.each_with_object({}).with_index{ |(seed_bag, hash), index| hash["#{index+1}. #{seed_bag.crop_type.crop_name}"] = seed_bag}
    #=> {"1. Turnip"=> <seed_bag_instance>, "2. Tomato"=> <seed_bag_instance>}
  end

  # Reusable warning notice
  def notice(string)
    puts "-------------------------------------------"
    puts ""
    puts string.colorize(:red)
    puts ""
    puts "-------------------------------------------"
    puts ""
  end

  # Method for farming actions that affect the field
  def farming(action)
    hash = seed_bag_hash{action[:search]}
    if hash.empty?
      system("clear")
      notice(action[:empty])
      go_to_field
    else
      if action == planting
        brief_inventory
      end
      choice = select_prompt(action[:choose], hash)
      if action == harvesting
        choice.update(planted: 0)
      end
      choice.update(action[:action])
      system("clear")
      notice(action[:done])
      go_to_field
    end
  end

  # Hash containing planting actions
  def planting
    {
      search: farmer.seed_bags.where("planted = ?", 0).where("harvested = ?", 0),
      empty: "You have no seeds you can plant!",
      choose: "Which seed would you like to plant?",
      done: "Planted!",
      action: {planted: 1}
    }
  end

  # Hash containing harvesting actions
  def harvesting
    {
      search: farmer.seed_bags.where("planted = ?", 1).where("ripe = ?", 1),
      empty: "You have no crops you can harvest right now!",
      choose: "What would you like to harvest?",
      done: "Harvested!",
      action: {harvested: 1}
    }
  end

  # Hash containing watering actions
  def watering
    {
      search: farmer.seed_bags.where("planted = ?", 1).where("watered = ?", 0).where("ripe = ?", 0),
      empty: "You have no crops that need to be watered!",
      choose: "Which crop would you like to water?",
      done: "Watered!",
      action: {watered: 1}
    }
  end

  # Briefly lists seed bags in inventory
  def brief_inventory
    puts "SEED BAGS IN INVENTORY".colorize(:yellow)
    seed_bag_inventory_hash.each do |crop_name, amount|
      puts "#{crop_name}".upcase.bold + " x#{amount}"
    end
    #=> TURNIP x4
    #=> TOMATO x1
  end

  # Method called to start the game
  def game_start
    opening
    first_menu
  end

  # Opening header
  def opening
    system("clear")
    # open "./audio/01 - Wonderful Life.mp3"
    puts "==========================================="
    puts ""
    puts "Welcome to Harvest Moon: Command Line Town!"
    puts ""
    puts "==========================================="
    puts ""
  end

  # Menu options
  def opening_menu_options
    if Farmer.all.empty?
      ["New Game", "Exit"]
    else
      ["New Game", "Load Game", "Exit"]
    end
  end

  # First/opening menu options
  def first_menu
    choice = select_prompt("", opening_menu_options)
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

  # Start a New Game by creating a new Farmer
  def character_creation
    farmer_name = naming_prompt("What's your Farmer's name?")
    self.farmer = Farmer.create(
      name: farmer_name,
      day: 1,
      season: "fall",
      money: 2000,
      dog: "Astro"
    )
    puts "You are Farmer #{self.farmer.name}. Welcome!"
    puts ""
    puts "-------------------------------"
    puts ""
    # prompt = TTY::Prompt.new
    # dog_name = prompt.ask("What is your dog's name?", required: true)
    # farmer.update(dog: dog_name)
    sleep(2.seconds)
    game_menu
  end

  # Select an existing Farmer
  def character_menu
    choice = select_prompt("Choose a File", Farmer.pluck("name"))
    self.farmer = Farmer.find_by(name: choice)
    notice("Welcome back, Farmer #{self.farmer.name}!")
    puts ""
    sleep(2.seconds)
    game_menu
  end

  # Header UI
  def status
    puts "Farmer #{farmer.name}".bold.colorize(:color => :black, :background => :light_white)
    puts "🌖 Day #{farmer.day}"
    puts "💰 #{farmer.money} G"
  end

  def main_menu_options
    [ "Inventory", "Field", "Home", "Market", "Exit" ]
  end

  def game_menu
    system("clear")
    status
    choice = select_prompt("MAIN MENU", main_menu_options)
    system("clear")
    case choice
    when "Inventory"
      show_inventory
      select_prompt("Press Enter to Exit.", ["Exit"])
      game_menu
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
    end
    #=> {"turnip"=>2, "radish"=>5} For unplanted seed bags
  end

  def ripe_seed_inventory_hash
    seed_name_array = farmer.crop_types.where("planted = ?", 0).where("harvested = ?", 1).pluck("crop_name")
    seed_name_array.each_with_object(Hash.new(0)) do |crop_name, inv_hash|
      inv_hash[crop_name] += 1
    end
    #=> {"turnip"=>2, "radish"=>5} For harvested crops
  end

  def show_inventory
    system("clear")
    puts "==========================================="
    puts "                INVENTORY"
    puts "==========================================="
    puts ""
    if !seed_bag_inventory_hash.empty?
      rows = []
      seed_bag_inventory_hash.each do |seed_bag, amount_owned|
        crop = CropType.find_by(crop_name: seed_bag)
        one_row = []
        one_row << "#{seed_bag}".upcase.bold
        one_row << "#{crop.days_to_grow}"
        one_row << "x#{amount_owned}"
        rows << one_row
      end
      table = Terminal::Table.new :title => "SEED BAGS".colorize(:yellow), :headings => ['Name', 'Days to Grow', 'Amount Owned'], :rows => rows
      table.align_column(1, :center)
      table.align_column(2, :center)
      puts table
    else
      puts "SEED BAGS".colorize(:yellow)
      puts "None."
      puts "-------------------------------------------"
    end
    puts ""
    if !ripe_seed_inventory_hash.empty?
      rows = []
      ripe_seed_inventory_hash.each do |ripe_seed, amount_owned|
        crop = CropType.find_by(crop_name: ripe_seed)
        one_row = []
        one_row << "#{ripe_seed}".upcase.bold
        one_row << "#{crop.sell_price} G"
        one_row << "x#{amount_owned}"
        rows << one_row
      end
      table = Terminal::Table.new :title => "HARVESTED CROPS".colorize(:light_green), :headings => ['Name', 'Price per Crop','Amount Owned'], :rows => rows
      table.align_column(1, :center)
      table.align_column(2, :center)
      puts table
    else
      puts "HARVESTED CROPS".colorize(:light_green)
      puts "None."
      puts "-------------------------------------------"
    end
    puts ""
    # game_menu
  end

  def field_array
    [ "Water", "Plant", "Harvest", "Destroy", "Exit" ]
  end

  # list of planted crops and their watered status
  def print_planted_seeds
    planted_seed_array = farmer.seed_bags.where("planted = ?", 1)
    if planted_seed_array.empty?
      notice("Your field is empty!\nWhy not try planting some seeds?")
    else
      planted_seed_array.each do |seed_bag|
        puts "#{seed_bag.crop_type.crop_name}".upcase.bold
        puts "Growth: #{(seed_bag.growth/seed_bag.crop_type.days_to_grow.to_f*100).round(1)}%"
        if seed_bag.ripe?
          puts "Soil: This crop is ready to be harvested!".colorize(:light_green)
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
      farming(planting)
    when "Water"
      farming(watering)
    when "Harvest"
      farming(harvesting)
    when "Destroy"
      planted_array = farmer.seed_bags.where("planted = ?", 1)

      if planted_array.empty?
        system("clear")
        notice("There's nothing in your field to destroy!")
        go_to_field
      else
        #puts brief numbered list of field crops
        planted_array.each_with_index do |planted_seed_bag, index|
          puts "#{index+1}. #{planted_seed_bag.crop_type.crop_name}     Growth: #{(planted_seed_bag.growth/planted_seed_bag.crop_type.days_to_grow.to_f*100).round(1)}%"
        end

        planted_hash = seed_bag_hash{planted_array}
        #planted_array.each_with_object({}).with_index{ |(seed_bag, hash), index| hash["#{index+1}. #{seed_bag.crop_type.crop_name}"] = seed_bag}
        choice = select_prompt("What would you like to destroy?", planted_hash)
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
          system("clear")
          notice("The crop was destroyed...")
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
    status
    puts "==========================================="
    puts "               MARKETPLACE"
    puts "==========================================="
    choice = select_prompt("Vendor: Hello! What would you like to do?", ["Buy", "Sell", "Exit"])
    case choice
    when "Buy"
      #list of seeds and prices
      puts "==========================================="
      puts ""
      rows = []
      CropType.all.each do |crop_type|
        one_row = []
        one_row << "#{crop_type.crop_name}".upcase.bold
        one_row << "#{crop_type.days_to_grow}".bold
        one_row << "#{crop_type.buy_price}".bold + " G"
        rows << one_row
      end
      market_table = Terminal::Table.new :title => "Fall Crops on Sale".bold.colorize(:magenta), :headings => ['Name', 'Days to Grow', 'Price'], :rows => rows
      market_table.align_column(1, :center)
      market_table.align_column(2, :center)
      puts market_table
      puts ""

      #new prompt selecting from list of seeds to buy
      choice = select_prompt("What would you like to purchase?", CropType.pluck("crop_name"))
      chosen_bag = CropType.find_by(crop_name: choice)
      confirmation = select_prompt("Buy one bag of #{choice}?", ["Yes", "No"])
      case confirmation
      when "Yes"
        new_crop = farmer.buy_seed_bag(chosen_bag)
        farmer.money -= chosen_bag.buy_price
        farmer.save
        system("clear")
        notice("You bought a bag of #{choice} seeds!")
        go_to_market
        # binding.pry
      when "No"
        system("clear")
        go_to_market
      end
    when "Sell"
      if ripe_seed_inventory_hash.empty?
        system("clear")
        notice("Vendor: Doesn't look like you have any crops to sell me.")
      else
        total = 0
        ripe_seed_inventory_hash.each do |crop_name, amount|
          crop = CropType.find_by(crop_name: crop_name)
          subtotal = crop.sell_price * amount
          puts "#{crop_name}".upcase.bold.colorize(:magenta) + " x #{amount} = #{subtotal} G"
          total += subtotal
        end
        puts "TOTAL: #{total} G".bold.colorize(:light_green)
        choice = select_prompt("Would you like to ship all your crops for #{total} G?", ["Yes, sell them all!", "No"])
        case choice
        when "Yes, sell them all!"
          to_sell = farmer.seed_bags.where("planted = ?", 0).where("harvested = ?", 1)
          to_sell.each do |seed_bag|
            seed_bag.destroy
          end
          farmer.money += total
          farmer.save
          notice("You sold all your crops for a profit!\nYou now have #{farmer.money} G.")
          sleep(2.seconds)
          system("clear")
        end
      end
      # system("clear")
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
    puts "                  HOME"
    puts "==========================================="
    puts ""
    puts "#{farmer.dog}".colorize(:magenta) + " is quietly snoring on your bed..."
    # puts ""
    # puts "... But this is no time for resting!"
    # puts "* You head back outside. *".italic
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
