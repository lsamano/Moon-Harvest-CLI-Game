### PRODUCTION LOG

Dec 23, 2018
- Created Start Screen Menu (New Game, Load Game, Exit).
  - User can create a farmer or select from existing farmers.

Dec 22, 2018
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
