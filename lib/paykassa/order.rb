require 'net/http'

class PaykassaOrder
  BASE_SCI_URI = URI('https://paykassa.pro/sci/0.3/index.php')
  CURRENCIES=[
    "USD", "RUB", "BTC", "ETH", "LTC", "DOGE", "DASH", "BCH", "ZEC",
    "XRP", "TRX", "XLM", "BNB", "USDT", "ADA", "EOS", "GBP", "EUR", 
    "USDC", "BUSD"
  ]
    SYSTEM_IDS = {
        perfectmoney: 2,
        berty: 7,
        bitcoin: 11,
        ethereum: 12,
        litecoin: 14,
        dogecoin: 15,
        dash: 16,
        bitcoincash: 18,
        zcash: 19,
        ripple: 22,
        tron: 27,
        stellar: 28,
        binancecoin: 29,
        tron_trc20: 30,
        binancesmartchain_bep20: 31, # available currencies USDT, BUSD, USDC, ADA, EOS, BTC, ETH, DOGE    
        ethereum_erc20: 32
    }

  # def initialize(auth)
  # where auth has keys: sci_id, sci_key, domain
  def initialize(auth, logger = nil, test = false)
    @logger = logger
    @_auth = auth
    @test = test
  end

  # Request for create order
  def create_order(amount: , currency:, order_id:, paid_commision: , comment:, system:)
    data =  {
      func: :sci_create_order,
      amount: amount,
      currency: currency,
      order_id: order_id,
      phone: "false",
      paid_commission: paid_commision,
      comment: comment,
      system: SYSTEM_IDS[system]
    }
    puts data.inspect
    make_request(
     data
    )
  end
  def get_data(amount: , currency:, order_id:, paid_commission: , comment:, system:)
    data = {
      func: :sci_create_order_get_data,
      amount: amount,
      currency: currency,
      order_id: order_id,
      phone: "false",
      paid_commission: paid_commission,
      comment: comment,
      system: SYSTEM_IDS[system]
    }
    puts data.inspect
    make_request(data)
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