class Farmer < ActiveRecord::Base
  has_many :seed_bags, :dependent => :destroy
  has_many :crop_types, through: :seed_bags
  has_many :livestocks, :dependent => :destroy
  has_many :products, :dependent => :destroy
  has_many :animals, through: :livestocks

  def buy_seed_bag(crop_type)
    SeedBag.create(
      "farmer_id": self.id,
      "crop_type_id": crop_type.id
    )
  end
end
