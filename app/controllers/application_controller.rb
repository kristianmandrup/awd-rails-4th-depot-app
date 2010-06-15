class ApplicationController < ActionController::Base
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
end
