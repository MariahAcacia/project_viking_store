class Admin::CreditCardsController < ApplicationController

  def index
  end


  def new
    @user = User.find(params[:user_id])
    @cc = CreditCard.new
  end


  def create
    @cc = CreditCard.new(whitelisted_params)
    if @cc.save
      flash[:success] = "Credit Card Successfully Added to User Profile"
      redirect_to admin_user_path(@cc.user)
    else
      flash[:danger] = "Credit Card Could NOT be Added to User Profile - See Errors on Form"
      render :new
    end
  end


  def show
    @cc = CreditCard.find(params[:id])
  end


  def edit
    @cc = CreditCard.find(params[:id])
  end


  def update
    @cc = CreditCard.find(params[:id])
    if @cc.update(whitelisted_params)
      flash[:success] = "Credit Card Successfully Added to User Profile"
      redirect_to admin_user_path(@cc.user)
    else
      flash[:danger] = "Credit Card Could NOT be Added to User Profile - See Errors on Form"
      render :edit
    end
  end


  def destroy
    @credit_card = CreditCard.find(params[:id])
    if @credit_card.destroy
      flash[:success] = "Credit Card Successfully Deleted"
      redirect_to admin_user_path(@credit_card.user)
    else
      flash[:danger] = "User ##{@user.id} Could Not be Deleted"
      redirect_to admin_user_path(@credit_card.user)
    end
  end



  private


  def whitelisted_params
    params.require(:credit_card).permit(:id, :card_number, :exp_month, :exp_year, :brand, :user_id, :ccv)
  end

end
