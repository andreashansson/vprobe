class Scriptconfig < ActiveRecord::Base
  belongs_to :script
  belongs_to :testconfig
end
