class Farmer < ActiveRecord::Base
  has_many :seed_bags, :dependent => :destroy
  has_many :crop_types, through: :seed_bags

  # Farmer.pluck("name")
  # def self.array_of_farmer_names
  #   all.map{ |farmer| farmer.name}
  # end

  # alexi.crops.new(seed_bag_id:1)
  def buy_seed_bag(crop_type)
    SeedBag.create(
      "farmer_id": self.id,
      "crop_type_id": crop_type.id,
      "growth": 0,
      "watered": 0,
      "harvested": 0,
      "planted": 0,
      "ripe": 0
    )
  end
end
