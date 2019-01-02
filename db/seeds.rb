# require_relative '../config/environment'
# Farmer.destroy_all
# Farmer.create(name: "Yeye")

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
