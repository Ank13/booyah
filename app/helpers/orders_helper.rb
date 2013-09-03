module OrdersHelper
  # @lob = Lob(api_key: ENV['LOB_KEY'])
  def create_new_order(user, picture)
    p environment
    picture = 'https://dl.dropboxusercontent.com/u/22698720/test_pdf.pdf' if environment == 'local' || environment == 'test'
    p picture
    address = user.addresses.first
    p address
    @lob = Lob(api_key: ENV['LOB_KEY'])
    postcard = @lob.postcards.create(
      "#{user.first_name} #{user.last_name}\'s Order",
      user.addresses.first.lob_address_id,
      message: "Thanks for using Booyah!",
      front: picture, #stubbed image
      from: booyah_address
    )
    p postcard
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

  def booyah_address
    {
      name: "Booyah!", 
      address_line1: "22 Weatherby ct.",
      address_line2: '',
      city: "Petaluma", 
      state: "CA", 
      zip: "94954", 
      country: "US"
    }
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