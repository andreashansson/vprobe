class ScriptsController < ApplicationController
  rescue_from ActionController::ParameterMissing, with: :error_occured
  before_action :set_script, only: [:show, :edit, :update, :destroy]
  check_authorization
  load_and_authorize_resource

  # GET /scripts
  # GET /scripts.json
  def index
    @scripts = Script.all
    @script = Script.new
  end

  # GET /scripts/1
  # GET /scripts/1.json
  def show
  end

  # GET /scripts/new
  def new
    @script = Script.new
  end

  # GET /scripts/1/edit
  def edit
  end

  # POST /scripts
  # POST /scripts.json
  # format.html { redirect_to scripts_path flash[:new_script] = @script, flash[:error_notice] = 'You must choose a file.' }

  def create
      @script = Script.new(name: script_params[:file].original_filename, body: script_params[:file].read.gsub(/\r\n?/,"\n"), version: 1)

      #@script.name = script_params[:file].original_filename
      #@script.body = script_params[:file].read.gsub(/\r\n?/,"\n")
      #@script.version = 1
      #params.fetch(:script, {})
      #assign_file_contents(@script)
      #debugger
      #puts "s"
      #@script = assign_file_contents(script_params)

      respond_to do |format|
        if script_params[:file]
            if @script.save
                #@script.increment!(:version)
                format.html { redirect_to scripts_path flash[:new_script] = @script, flash[:create_notice] = ' was successfully created.' }
                format.json { render :show, status: :created, location: @script }
            else
                format.html { redirect_to scripts_url flash[:new_script] = @script, flash[:error_notice] = @script.errors.full_messages }#, notice: "@script.errors" }
                format.json { render json: @script.errors, status: :unprocessable_entity }
            end
        else
            format.html { redirect_to scripts_url, notice = "You must choose a file!"}#, notice: "@script.errors" }
            format.json { render json: @script.errors, status: :unprocessable_entity }
        end
    end
  end


  # PATCH/PUT /scripts/1
  # PATCH/PUT /scripts/1.json
  def update
    # When updating a script we need to update the version for any config using
    # the script as well.

    # Denna plockar ut alla script_id i Scriptconfig tabellen som stämmer med idt för scriptet vi vill uppdatera
    @scriptconfigs = Scriptconfig.where(script_id: params[:id])

    @scriptconfigs.each do |sc|
      @testconfig = Testconfig.find(sc.testconfig_id)
      @testconfig.increment!(:version)
    end

    filename = script_params[:file].original_filename
    body = script_params[:file].read.gsub(/\r\n?/,"\n")

    respond_to do |format|

        if @script.update(name: filename, body: body)
          @script.increment!(:version)
          format.html { redirect_to scripts_url flash[:updated_script] = @script, flash[:script_configs] = @scriptconfigs, flash[:updated_notice] = 'Script was successfully updated.' }
          format.json { render :show, status: :ok, location: @script }
        else
          format.html { redirect_to scripts_url flash[:updated_script] = @script, flash[:error_notice] = @script.errors.full_messages }
          format.json { render json: @script.errors, status: :unprocessable_entity }
        end
      #end
    end
  end
  # DELETE /scripts/1
  # DELETE /scripts/1.json
  def destroy
    @script.destroy
    respond_to do |format|
      format.html { redirect_to scripts_url flash[:deleted_script] = @script.destroy, flash[:destroy_notice] = ' was successfully deleted.' }
      format.json { head :no_content }
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
  def set_script
    @script = Script.find(params[:id])
  end

    # Never trust parameters from the scary internet, only allow the white list through.
  def script_params
    params.require(:script).permit(:name, :body, :version, :file)
  end

  def error_occured
    redirect_to scripts_url flash[:script] = @script, flash[:error_notice] = "Missing new script file."
  end

  def sanitize_filename(filename)
    return File.basename(filename)
  end
end
