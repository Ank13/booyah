class AddressesController < ApplicationController
  def new
    @address = Address.new
  end

  def create
    if address = verify_and_create_address(params[:address])
      redirect_to user_path(current_user)
    else 
      redirect_to new_user_address_path(current_user, :error => 'That address does not exist')
    end
  end

  def edit
    @user = User.find(params[:user_id])
    @address = @user.address
  end

  def update
    user = User.find(params[:user_id])
    address = Address.find(params[:id])
    if address = verify_and_update_address(address, params[:address])
      redirect_to user_path(current_user)
    else 
      redirect_to edit_user_address_path(current_user, params[:id], :error => 'That address does not exist')
    end
  end
end
