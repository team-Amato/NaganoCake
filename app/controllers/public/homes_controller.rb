class Public::HomesController < ApplicationController
  def top
    @genres = Genre.all
    @items = Item.all
  end
end
