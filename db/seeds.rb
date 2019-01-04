# require_relative '../config/environment'
# Farmer.destroy_all
# Farmer.create(name: "Yeye")

yeye = Farmer.first
cow = Animal.create(species: "cow", product_name: "milk", sell_price: 400, frequency: 1)
sheep = Animal.create(species: "sheep", product_name: "wool", sell_price: 1000, frequency: 3)

bessie = Livestock.create(animal_id: cow.id, farmer_id: yeye.id, name: "Bessie", love: 1, brushed: 0, fed: 0, counter: 1)
wooly = Livestock.create(animal_id: sheep.id, farmer_id: yeye.id, name: "Wooly", love: 1, brushed: 0, fed: 0, counter: 1)

Product.create(livestock_id: bessie.id)
Product.create(livestock_id: wooly.id)

# ### Fall Crops
# CropType.create(
#   crop_name: "carrot",
#   days_to_grow: 6,
#   buy_price: 390,
#   season: "fall",
#   sell_price: 1710
# )
# CropType.create(
#   crop_name: "sweet potato",
#   days_to_grow: 6,
#   buy_price: 240,
#   season: "fall",
#   sell_price: 990
# )
# CropType.create(
#   crop_name: "spinach",
#   days_to_grow: 5,
#   buy_price: 440,
#   season: "fall",
#   sell_price: 1890
# )
# CropType.create(
#   crop_name: "eggplant",
#   days_to_grow: 11,
#   buy_price: 480,
#   season: "fall",
#   sell_price: 4140
# )
# CropType.create(
#   crop_name: "bell pepper",
#   days_to_grow: 11,
#   buy_price: 510,
#   season: "fall",
#   sell_price: 2250
# )
