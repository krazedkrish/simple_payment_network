class StocksController < ApplicationController
  def index
    @stocks = Stock.includes(:wallet).all.page params[:page]
  end

  def show
    @stock = Stock.includes(:wallet).find(params[:id])
  end
end
