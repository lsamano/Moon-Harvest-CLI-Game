class Farmer < ActiveRecord::Base
  has_many :crops, :dependent => :destroy
  has_many :seed_bags, through: :crops

  # Farmer.pluck("name")
  # def self.array_of_farmer_names
  #   all.map{ |farmer| farmer.name}
  # end

  # alexi.crops.new(seed_bag_id:1)
  def buy_seed_bag(seed_bag)
    Crop.create(
      "farmer_id": self.id,
      "seed_bag_id": seed_bag.id,
      "days_planted": 0,
      "watered?": 0,
      "harvested?": 0
    )
  end
end
