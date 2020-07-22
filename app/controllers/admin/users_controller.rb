class Admin::UsersController < ApplicationController

  layout 'admin_portal_layout'

  STATES = ["AL", "AK", "AZ", "AR", "CA", "CO", "CT", "DE", "FL", "GA", "HI", "ID", "IL", "IN", "IA", "KS", "KY", "LA", "ME", "MD",
            "MA", "MI", "MN", "MS", "MO", "MT", "NE", "NV", "NH", "NJ", "NM", "NY", "NC", "ND", "OH", "OK", "OR", "PA", "RI", "SC",
            "SD", "TN", "TX", "UT", "VT", "VA", "WA", "WV", "WI", "WY"]

  def index
    @users = User.all
  end


  def new
    set_states
    @user = User.new
    @address = @user.addresses.build
  end


  def create
    @user = User.new(whitelisted_params)
    if @user.save
      shipping = create_address_from_params(@user, whitelisted_params[:shipping_id])
      billing = create_address_from_params(@user, whitelisted_params[:billing_id])
      @user.billing_id = billing.id
      @user.shipping_id = shipping.id
      if @user.save
        flash[:success] = "User ##{@user.id} Successfully Saved!"
        redirect_to admin_users_path
      end
    else
      flash[:danger] = "User Could Not Be Saved See Errors On Form"
      render :new
    end
  end


  def show
    @user = User.find(params[:id])
    if CreditCard.exists?(user_id: @user.id)
      @cc = CreditCard.where(user_id: @user.id).first
    end
    @orders = Order.where(user_id: @user.id)
    @shopping_cart = @orders.where(checkout_date: nil).ids
    unless @user.billing_id.nil?
      @billing_addy = Address.find(@user.billing_id)
    end
    unless @user.shipping_id.nil?
      @shipping_addy = Address.find(@user.shipping_id)
    end
  end


  def edit
    @user = User.find(params[:id])
  end


  def update
    @user = User.find(params[:id])
    if @user.update_attributes(whitelisted_params)
      flash[:success] = "User ##{@user.id} Successfully Updated!"
      redirect_to admin_user_path(params[:id])
    else
      flash[:danger] = "User ##{@user.id} Could Not Be Updated See Errors On Form"
      render :edit
    end
  end


  def destroy
    @user = User.find(params[:id])
    if @user.destroy
      flash[:success] = "User ##{@user.id} Successfully Deleted"
      redirect_to admin_users_path
    else
      flash[:danger] = "User ##{@user.id} Could Not be Deleted"
      redirect_to admin_user_path(@user)
    end
  end


  private


  def create_address_from_params(user, params)
    city = City.create(name: params[:city])
    address = Address.create(user_id: user.id,
                   street_address: params[:street_address],
                   zip_code: params[:zip_code],
                   city_id: city.id,
                   state_id: params[:state_id],
                 )
   address
  end

  def whitelisted_params
    params.require(:user).permit(:first_name, :last_name, :email, :telephone, { shipping_id: [:id, :street_address, :city, :state_id, :zip_code, :_destroy] },
                                                                              { billing_id: [:id, :street_address, :city, :state_id, :zip_code, :_destroy] }, :shipping_id, :billing_id)
  end

  def set_states
    if State.count < 1
      STATES.each {|state| State.create(name: state)}
    end
  end


end
