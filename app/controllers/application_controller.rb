class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception
  before_action :set_locale
  before_action :authenticate_user!
  before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    dashboard_path
  end

  protected

  def set_locale
    logger.debug "* Accept-Language: #{request.env['HTTP_ACCEPT_LANGUAGE']}"

    I18n.locale =  get_client_locale

    logger.debug "* Locale set to '#{I18n.locale}'"
  end

  def get_client_locale
    extract_locale = extract_locale_from_accept_language_header

    available_locales = I18n.available_locales.map(&:to_s)

    locale_detected = available_locales.find { |i| i[/#{extract_locale}*/] }

    locale_detected ||= I18n.default_locale
  end

  def extract_locale_from_accept_language_header
    request.env['HTTP_ACCEPT_LANGUAGE'].scan(/^[a-z]{2}/).first.downcase
  end

  def configure_permitted_parameters
    devise_parameter_sanitizer.permit(:sign_up, keys: [:username])
  end
end
