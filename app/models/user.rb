class User < IcomeraUserManagement::SessionUser
  validates_numericality_of :time_limit, only_integer: true
  validates :time_limit, presence: true, numericality: { only_integer: true }
  validates :role, presence: true, inclusion: { in: %w(user pro admin) }

  def customers
    Customer.where(icomera_id: customer_ids)
  end

  def customers=(new_customers)
    self.customer_ids = new_customers.map(&:icomera_id)
  end

  def role
    setting(:role)
  end

  def role=(new_role)
    set_setting(:role, new_role)
  end

  def time_limit
    setting(:time_span)
  end

  def time_limit=(new_time_limit)
    set_setting(:time_span, new_time_limit)
  end

  def admin?
    role == "admin"
  end

  def pro?
    role == "pro"
  end

  def time_restriction
    if admin?
      Time.at(0)
    else
      time_limit.minutes.ago
    end
  end

  def self.default_role
    "user"
  end

  def self.time_limits
    [
      60, 720, 1440, 2880, 4320, 5760, 7200,
      8640, 10_080, 11_520, 12_960, 14_400, 15_840,
      17_280, 18_720, 20_160
    ]
  end

  def self.roles
    %w(user pro admin)
  end

  def self.current_user
    RequestStore.store[:current_user]
  end

  def self.current_user=(new_current_user)
    RequestStore.store[:current_user] = new_current_user
  end
end
