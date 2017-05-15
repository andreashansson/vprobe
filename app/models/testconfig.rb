class Testconfig < ActiveRecord::Base
  has_many :scriptconfigs
  has_many :scripts, through: :scriptconfigs, :dependent => :delete_all
  has_many :groups
  validates :name, :presence => true
  accepts_nested_attributes_for :scripts, :scriptconfigs
end
