module OrdersHelper
  # @lob = Lob(api_key: ENV['LOB_KEY'])
  def create_new_order(user, picture)
    address = user.addresses.first
    @lob = Lob(api_key: ENV['LOB_KEY'])
    postcard = @lob.postcards.create(
      "#{user.first_name} #{user.last_name}\'s Order",
      user.addresses.first.lob_address_id,
      message: "Thanks for using Booyah!",
      front: picture,
      from: Rails.env.production? ? 'adr_d06d2d0316a1cd0f' : 'adr_5860b42d2df0309e'
    )
    if postcard
      order = Order.create( :user_id => user.id,
                            :to_id => postcard['to'],
                            :order_id => postcard['id'],
                            :lob_cost => postcard['price'],
                            :user_cost => 1.50
                          )
      user.orders << order
    else
      postcard
    end
  end

  def create_new_address(address_params)
    @lob = Lob(api_key: ENV['LOB_KEY'])
    new_address = Address.new(address_params)
    address_params.merge!(  :name => current_user.full_name,
                            :email => current_user.email,
                            :phone => current_user.cell
                          )
    new_lob_address = @lob.addresses.create(address_params)
    new_address.lob_address_id = new_lob_address['id']
    new_address.save
    current_user.addresses << new_address
    new_lob_address
  end

  def verify_and_create_address(address_params)
    @lob = Lob(api_key: ENV['LOB_KEY'])
    begin
      @lob.addresses.verify(address_params.dup)
      create_new_address(address_params)
    rescue
      false
    end
  end
end