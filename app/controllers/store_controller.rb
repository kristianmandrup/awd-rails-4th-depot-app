class StoreController < ApplicationController
  def index
    @products = Product.all
    @cart = find_or_create_cart
  end

end
