class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  before_action :authenticate_user!
  before_action :set_mode

  rescue_from CanCan::AccessDenied do |exception|
    redirect_to root_url, alert: exception.message
  end

  rescue_from ActiveRecord::RecordNotFound do
    render nothing: true, status: :not_found
  end

  check_authorization

  private

  def current_user
    # RequestStore.store[:current_user] ||= User.create_from_session_and_request(session, request, super)
    User.current_user ||= User.create_from_session_and_request(session, request, super)
  end
  helper_method :current_user

  # Make current_user available outside controllers
  def set_current_user
    RequestStore.store[:current_user] = current_user
  end

  def ensure_customer
    if customer
      authorize! :read, @_customer
    else
      redirect_to root_path
    end
  end

  def customer
    @_customer = @customer = current_user.customers.find(params[:id])
  end
  helper_method :customer

  def signed_in?
    current_user.present?
  end
  helper_method :signed_in?

  def set_mode
    session[:mode] = "normal"
  end
  # Returns true if the current mode is the supplied parameter.
  def mode?(mode)
    session[:mode] == mode.to_s
  end
  helper_method :mode?
end
