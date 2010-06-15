class ApplicationController < ActionController::Base
  before_filter :set_i18n_locale_from_params
  # ...
  before_filter :authorize
  protect_from_forgery
  layout 'application'

  private

    def find_or_create_cart 
      Cart.find(session[:cart_id])
    rescue ActiveRecord::RecordNotFound
      cart = Cart.create
      session[:cart_id] = cart.id
      cart
    end

    # ...

  protected
    def authorize
      if request.format == Mime::HTML 
        unless User.find_by_id(session[:user_id])
          redirect_to login_url, :notice => "Please log in"
        end
      else
        authenticate_or_request_with_http_basic do |username, password|
          User.authenticate(username, password)
        end
      end
    end

    def set_i18n_locale_from_params
      if params[:locale]
        if I18n.available_locales.include?(params[:locale].to_sym)
          I18n.locale = params[:locale]
        else
          flash.now[:notice] = 
            "#{params[:locale]} translation not available"
          logger.error flash.now[:notice]
        end
      end

    end

    def default_url_options
      { :locale => I18n.locale }
    end
end
