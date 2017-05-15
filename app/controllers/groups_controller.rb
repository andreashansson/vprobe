class GroupsController < ApplicationController
  before_action :set_group, only: [:show, :edit, :update, :destroy]
  check_authorization
  load_and_authorize_resource
  # GET /groups
  # GET /groups.json
  def index
    @groups = Group.where(customers_id: current_user.current_customer_id)
    @group = Group.new

    if @groups.empty?
      Group.create_default_group(current_user.current_customer_id)
    end
    #@config = Testconfig.find(Group.find(current_user.current_customer_id).testconfig_id)
    @testconfig_id = @groups.first.customers_id
    @customer_id = current_user.current_customer_id
    #@latest_added_group = Group.where(customers_id: current_user.current_customer_id).last

  end

  # GET /groups/1
  # GET /groups/1.json
  def show
    @group = Group.find(params[:id])
    @config = Testconfig.find(@group.testconfig_id)
  end

  # GET /groups/new
  def new
    @group = Group.new
    @customer_id = current_user.current_customer_id
  end

  # GET /groups/1/edit
  def edit
    @customer_id = current_user.current_customer_id
  end

  def list
    @groups = Group.all
  end

  # POST /groups
  # POST /groups.json
  def create

    @group = Group.new(group_params)
    respond_to do |format|
      if @group.save
        format.html { redirect_to groups_path flash[:new_group] = @group, flash[:create] = 'Group was successfully created.' }
        format.json { render :show, status: :created, location: @group }
      else
        format.html { render :new }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /groups/1
  # PATCH/PUT /groups/1.json
  def update
    respond_to do |format|
      if @group.update(group_params)
        format.html { redirect_to groups_path flash[:updated_group] = @group.update(group_params), flash[:update_notice] = 'Group was successfully updated.' }
        format.json { render :show, status: :ok, location: @group }
      else
        format.html { render :edit }
        format.json { render json: @group.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /groups/1
  # DELETE /groups/1.json
  def destroy
    @group.destroy
    respond_to do |format|
      format.html { redirect_to groups_path flash[:deleted_group] = @group.destroy, flash[:destroy_notice] = 'Group was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_group
      @group = Group.find(params[:id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def group_params
      params.require(:group).permit(:name, :testconfig_id, :url, :debug, :realm, :customers_id)
    end
end
#<%= f.select :config_id, Config.all.collect { |c| [ c.name, c.id ] } %>
