class TeamsController < ApplicationController
  def index
    @teams = Team.includes(:wallet).all.page params[:page]
  end

  def show
    @team = Team.includes(:users).find(params[:id])
  end
end
