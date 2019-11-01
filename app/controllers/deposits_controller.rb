class DepositsController < ApplicationController

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
    @deposit = Deposit.new
  end

  def create
    deposit = Deposit.new(deposit_params)
    if deposit.save
      flash[:notice] = 'Deposit has been requested'
      if deposit.amount > deposit.from_wallet.balance
        deposit.reject!
      else
        deposit.accept!
        TransactionsWorker.perform_async(deposit.id)
      end
    else
      flash[:error] = 'Deposit request failed'
    end
    redirect_to root_path
  end

  private

  def deposit_params
    params.require(:deposit).permit(:from_wallet_id, :to_wallet_id, :amount)
  end
end
