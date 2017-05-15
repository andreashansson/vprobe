class Api::ApiController < Api::BaseController
  before_filter :check_api_token

  before_filter :check_params
  before_filter :check_if_system_exists
  
  def get_config
    @system = System.where(systemid: params[:systemid]).first
    puts @system.inspect
    @group = Group.find(@system.group_id)
    @config = Testconfig.find(@group.testconfig_id)
    puts "config: #{@config.inspect}"
    if not check_version?(@config)
      return render json: {'status' => 0, 'note' => 'No new tests/configurations'}
    end
    @scriptconfigs = Scriptconfig.where(config_id:@config.id).all
    @scripts ||= []
    @scriptconfigs.each do |sc|
      script_temp = Script.find(sc.script_id)
      @scripts << {"name" => script_temp.name,
                    "body" => script_temp.body,
                    "params" => sc.script_params,
                    "version" => script_temp.version}
    end
    puts "scripts"
    puts @scripts

    @result = {'realm' => @group.realm, 'url' => @group.url,
               'debug' => @group.debug, 'tests' => @scripts,
               'version' => @config.version, 'status' => 1}
    
    render json: @result
  end

  # If system doesn't exist, lookup in Peak and create it.
  def check_if_system_exists
    if System.where(systemid: params[:systemid]).blank?
      create_new_system
    else
      return true
    end
  end

  private

  def error_test_url
    render json: {'error' => 'Only systemid and version are permitted parameters!'}
  end

  def create_new_system
    customerid = PeakConnector.get_customer_from_systemid(params[:systemid])
    if customerid == 0
      return render json:  {'error' => 'This systemid is not connected to any customer. Please self destruct!'}
    end

    if Group.where(name: 'Default Group', customers_id: customerid).blank?
      Group.create_default_group(customerid)
    end

    @group = Group.where(name: 'Default Group', customers_id: customerid).first
    puts "group: #{@group}"
    puts "group: #{@group.inspect}"
    @system = System.new(systemname: "New System",
                         systemid: params[:systemid],
                         group_id: @group.id)
    @system.save
  end
  
  def check_params
    error = false
    allowed_params = ['systemid', 'version', 'controller', 'action', 'format']

    params.keys.each do |key|
      if not key.in?(allowed_params)
        error = true
      end
    end
    if not (params.has_key?(:systemid) && params.has_key?(:version))
      error = true
    end
    if error == true
      render json:  {'error' => 'Only systemid and version are permitted parameters!'}
    else
      return true
    end
  end

  def check_version?(config)
    if Integer(params[:version]) != Integer(config.version)
      return true
    else
      return false
    end
  end


  
end
