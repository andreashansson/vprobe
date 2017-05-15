class Group < ActiveRecord::Base
  has_many :testconfigs #stod testconfig innan vet inte om s skall vara där.
  has_many :systems

  def self.create_default_group(customer_id)
      Group.create(name: 'Default Group',
                    debug: 0,
                    realm: 'default_realm',
                    customers_id: customer_id,
                    testconfig_id: Testconfig.last.id)
  end
end
