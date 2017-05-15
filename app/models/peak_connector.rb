class PeakConnector < PeakBase

  self.table_name = 'devices'

  def self.get_customer_from_systemid(systemid)
    query = "select customers.id from customers left join devices on devices.customer_id = customers.id where devices.system_id = #{systemid}"
    customer = connection.select_all(query)

    if customer.empty?
      puts "customer is empty"
      return 0
    end
    return customer.first.fetch('id')
  end
end
