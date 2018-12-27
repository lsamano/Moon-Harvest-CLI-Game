### PRODUCTION LOG

#Dec 27, 2018
- Added "seasons" column to seed_bags table.
- Added Fall crops to database.
  - Carrot, sweet potato, spinach, eggplant, bell pepper.
- Added counting method to count duplicate seed bags and print them neatly to
  the screen on the inventory page and planting screen (in Field).

    - Still need to:

#Dec 26, 2018
- Planned out crops database, setting, and plot.

#Dec 23, 2018
- Created Start Screen Menu (New Game, Load Game, Exit).
  - User can create a farmer or select from existing farmers.
- Created Main Game Menu (Status, Field, Market, Home, Exit).
  - Status: Check inventory and Farmer info.
  - Field: Check planted crops.
  - Market: Buy new seeds or sell grown crops.
  - Home: Sleep to advance to the next day.
  - Exit: Quit the game.
- User can create crop instances (buy from the market).
- Seed bag ownership is considered a part of the Crop instance (days = 0)

- Still need to:
  - Add functionality to all choices of the Main Game Menu except Exit.
  - Create SeedBag database with proper seeds in season.
  - Create Day counter of some sort.

#Dec 22, 2018
- Planned out app
  - "Lite" version of a farming simulator.
  - Create a farmer and grow and sell crops.
- Fixed environment and file connectivity
- Added models: Farmer, Crop, SeedBag, CommandLineInterface
- Created tables: farmers, crops, seed_bags
- Connected the above tables in a "has-many-through" relationship
  - Crop is the join table
  - CommandLineInterface is for UI actions (future TTYPrompt)

- Still need to:
  - Fill database with dummy data
  - Establish menu using TTYPrompt
    - Loop menu until the user exits the game
  - Allow user to perform CRUD actions
    - Create a farmer, plant crops (create crops)
    - Read farmer name, current crops, past crops
    - Update name, water plants
    - Destroy crops, sell crops
  - I may have to account for seed bag ownership and change relationships.
