class TestconfigsController < ApplicationController
  before_action :set_config, only: [:show, :edit, :update, :destroy]
  check_authorization
  load_and_authorize_resource

  # GET /configs
  # GET /configs.json
  def index
    @configs = Testconfig.all
    @config = Testconfig.new
    @scripts = Script.all

  end

  # GET /configs/1
  # GET /configs/1.json
  def show
  end

  # GET /configs/new
  def new
    @testconfig = Testconfig.new
    @scripts = Script.all
  end

  # GET /configs/1/edit
  def edit
    @scripts = Script.all
    @scriptconfigs = Scriptconfig.where(testconfig_id:params[:id])
  end

  # POST /configs
  # POST /configs.json
  def create
    puts "CREATE"
    @testconfig = Testconfig.new(testconfig_params)

    # Zip script array with params array
    scripts = params[:scripts]
    scriptparams = params[:scriptparams]
    scripts_arr = scripts.zip(scriptparams)

    respond_to do |format|
      if @testconfig.save
        # Need to add the script parameters to the join table entry.
        #@script = Script.find(@config.script_ids)
        scripts_arr.each do |script|
          puts "script: #{script.inspect}"
          scriptconfig = Scriptconfig.create :script_id => script[0],
                                             :testconfig_id => @testconfig.id,
                                             :script_params => script[1]
          scriptconfig.save
        end

        @testconfig.increment!(:version)
        #@sc = @config.scriptconfigs.where(script_id:@config.script_ids).first
        #@sc.script_params = scriptconfig_params[:script_params]
        #@sc.save
        format.html { redirect_to @testconfig, notice: 'Config was successfully created.' }
        format.json { render :show, status: :created, location: @testconfig }
      else
        format.html { render :new }
        format.json { render json: @testconfig.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /configs/1
  # PATCH/PUT /configs/1.json
  def update
    # Zip script array with params array
    scripts = params[:scripts]
    scriptparams = params[:scriptparams]
    scripts_arr = scripts.zip(scriptparams, params[:scriptconfig_ids], params[:deleted_ids])
    puts scripts_arr
    respond_to do |format|
      if @testconfig.update(testconfig_params)
        scripts_arr.each do |script|

          # check if scriptconfig should be deleted
          if script[3] == 'true'
            Scriptconfig.delete(script[2])
            next
          end

          if script[2].nil?
            scriptconfig = Scriptconfig.create :script_id => script[0],
                                             :testconfig_id => @testconfig.id,
                                             :script_params => script[1]
          else
            @scriptconfig = Scriptconfig.find(script[2])
            @scriptconfig.script_id = script[0]
            @scriptconfig.script_params = script[1]
            @scriptconfig.save
          end
        end

        @testconfig.increment!(:version)
        format.html { redirect_to @testconfig, notice: 'Config was successfully updated.' }
        format.json { render :show, status: :ok, location: @testconfig }
      else
        format.html { render :edit }
        format.json { render json: @testconfig.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /configs/1
  # DELETE /configs/1.json
  def destroy
    @testconfig.destroy
    respond_to do |format|
      format.html { redirect_to testconfigs_url, notice: 'Config was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_config
      @config = Testconfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def testconfig_params
      params.require(:testconfig).permit(:name, :version, :script_ids, scriptconfigs_attributes: [:script_params] )
    end
    #def scriptconfig_params
    #  params.require(:scriptparams).permit(:script_params)
    #end
end
