# Destroy Previous
Product.destroy_all
Livestock.destroy_all
SeedBag.destroy_all
CropType.destroy_all
Animal.destroy_all
Farmer.destroy_all

# Create Animals
cow = Animal.create(
  species: "cow",
  product_name: "milk",
  sell_price: 400,
  frequency: 1
  )
sheep = Animal.create(
  species: "sheep",
  product_name: "wool",
  sell_price: 1000,
  frequency: 3
  )

# Make New Default Farmer
farmer = Farmer.create(name: "Clarabelle")

# Create Livestock for Default Farmer
bessie = Livestock.create(animal_id: cow.id, farmer_id: farmer.id, name: "Bessie", love: 1, brushed: 0, fed: 0, counter: 1)
wooly = Livestock.create(animal_id: sheep.id, farmer_id: farmer.id, name: "Wooly", love: 1, brushed: 0, fed: 0, counter: 1)

# Create Products for Default Farmer
Product.create(livestock_id: bessie.id, farmer_id: farmer.id)
Product.create(livestock_id: wooly.id, farmer_id: farmer.id)

## Fall Crops
CropType.create(
  crop_name: "carrot",
  days_to_grow: 6,
  buy_price: 390,
  season: "fall",
  sell_price: 1710
)
CropType.create(
  crop_name: "sweet potato",
  days_to_grow: 6,
  buy_price: 240,
  season: "fall",
  sell_price: 990
)
CropType.create(
  crop_name: "spinach",
  days_to_grow: 5,
  buy_price: 440,
  season: "fall",
  sell_price: 1890
)
CropType.create(
  crop_name: "eggplant",
  days_to_grow: 11,
  buy_price: 480,
  season: "fall",
  sell_price: 4140
)
CropType.create(
  crop_name: "bell pepper",
  days_to_grow: 11,
  buy_price: 510,
  season: "fall",
  sell_price: 2250
)

## Summer Crops
# CropType.create(
#   crop_name: "pumpkin",
#   days_to_grow: 4,
#   buy_price: 180,
#   season: "summer",
#   sell_price: 1620
# )
# CropType.create(
#   crop_name: "watermelon",
#   days_to_grow: 7,
#   buy_price: 360,
#   season: "summer",
#   sell_price: 3060
# )
# CropType.create(
#   crop_name: "onion",
#   days_to_grow: 6,
#   buy_price: 270,
#   season: "summer",
#   sell_price: 1260
# )
# CropType.create(
#   crop_name: "corn",
#   days_to_grow: 14,
#   buy_price: 140,
#   season: "summer",
#   sell_price: 3960
# )
# CropType.create(
#   crop_name: "tomato",
#   days_to_grow: 12,
#   buy_price: 110,
#   season: "summer",
#   sell_price: 3240
# )
