class ScriptconfigsController < ApplicationController
  before_action :set_scriptconfig, only: [:show, :edit, :update, :destroy]
  check_authorization
  load_and_authorize_resource

  # GET /scriptconfigs
  # GET /scriptconfigs.json
  def index
    @scriptconfigs = Scriptconfig.all
  end

  # GET /scriptconfigs/1
  # GET /scriptconfigs/1.json
  def show
  end

  # GET /scriptconfigs/new
  def new
    @scriptconfig = Scriptconfig.new
  end

  # GET /scriptconfigs/1/edit
  def edit
  end

  # POST /scriptconfigs
  # POST /scriptconfigs.json
  def create
    @scriptconfig = Scriptconfig.new(scriptconfig_params)

    respond_to do |format|
      if @scriptconfig.save
        format.html { redirect_to @scriptconfig, notice: 'Scriptconfig was successfully created.' }
        format.json { render :show, status: :created, location: @scriptconfig }
      else
        format.html { render :new }
        format.json { render json: @scriptconfig.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /scriptconfigs/1
  # PATCH/PUT /scriptconfigs/1.json
  def update
    respond_to do |format|
      if @scriptconfig.update(scriptconfig_params)
        format.html { redirect_to @scriptconfig, notice: 'Scriptconfig was successfully updated.' }
        format.json { render :show, status: :ok, location: @scriptconfig }
      else
        format.html { render :edit }
        format.json { render json: @scriptconfig.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /scriptconfigs/1
  # DELETE /scriptconfigs/1.json
  def destroy
    @scriptconfig.destroy
    respond_to do |format|
      format.html { redirect_to scriptconfigs_url, notice: 'Scriptconfig was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_scriptconfig
      @scriptconfig = Scriptconfig.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def scriptconfig_params
      params.require(:scriptconfig).permit(:script_params, :config_id, :script_id)
    end
end
