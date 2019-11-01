class WithdrawsController < ApplicationController

  def new
    @type = params[:type]
    id = params[:id]
    if @type == "user"
      @user = User.find(id)
      @wallet = @user.wallet
    elsif @type == "team"
      @team = Team.find(id)
      @wallet = @team.wallet
    else
      @stock = Stock.find(id)
      @wallet = @stock.wallet
    end
    @wallets = Wallet.all
    @withdraw = Withdraw.new
  end

  def create
    withdraw = Withdraw.new(withdraw_params)
    if withdraw.save
      flash[:notice] = 'Withdraw has been requested'
      if withdraw.amount > withdraw.from_wallet.balance
        withdraw.reject!
      else
        withdraw.accept!
        TransactionsWorker.perform_async(withdraw.id)
      end
    else
      flash[:error] = 'Withdraw request failed'
    end
    redirect_to root_path
  end

  private

  def withdraw_params
    params.require(:withdraw).permit(:from_wallet_id, :to_wallet_id, :amount)
  end
end
