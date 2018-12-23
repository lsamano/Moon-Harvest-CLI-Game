class Farmer < ActiveRecord::Base
  has_many :crops
  has_many :seed_bags, through: :crops
end
