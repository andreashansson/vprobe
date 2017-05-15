class PeakBase < ActiveRecord::Base
  self.abstract_class = true
  establish_connection(:peak_db)
end
