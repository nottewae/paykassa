require 'net/http'

class PaykassaOrder
  BASE_SCI_URI = URI('https://paykassa.pro/sci/0.3/index.php')


  # def initialize(auth)
  # where auth has keys: sci_id, sci_key, domain
  def initialize(auth, logger = nil, test = false)
    @logger = logger
    @_auth = auth
    @test = test
  end

  # Request for create order
  def create_order(amount: , currency:, order_id:, paid_commision: , comment:, system:)
    make_request(
      func: :sci_create_order,
      amount: amount,
      currency: currency,
      order_id: order_id,
      phone: "false",
      paid_commission: paid_commision,
      comment: comment,
      system: system,
      test: @test.to_s
    )
  end
  def get_data(amount: , currency:, order_id:, paid_commision: , comment:, system:)
    make_request(
      func: :sci_create_order_get_data,
      amount: amount,
      currency: currency,
      order_id: order_id,
      phone: "false",
      paid_commission: paid_commision,
      comment: comment,
      system: system,
      test: @test.to_s
    )
  end

  # Check order status
  def confirm_order(private_hash)
    make_request(func: :sci_confirm_order, private_hash: private_hash)
  end

  private

  def make_request(data)
    res = Net::HTTP.post_form(BASE_SCI_URI, data.merge(@_auth))
    JSON.parse(res.body).deep_symbolize_keys
  end
end