class Crop < ActiveRecord::Base
  belongs_to :farmer
  belongs_to :seed_bag
end
