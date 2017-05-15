class Customer < ActiveRecord::Base
  has_many :groups
end
