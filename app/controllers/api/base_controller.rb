class Api::BaseController < ActionController::Base
  
  private

  def check_api_token
    unless request.headers['X-Token'] == Vprobe.config.vprobe_api_token
      render nothing: true, status: :forbidden and return
    end
  end
end
