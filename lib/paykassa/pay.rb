require 'net/http'
require 'logger'
class PaykassaPay 
    BASE_URL = URI("https://paykassa.app/api/0.5/index.php")
    RATE_URL = URI("https://currency.paykassa.pro/index.php")
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
    def initialize(domain:, api_id:, api_key:, test: false, logger: nil)
        @logger = logger
        @logger.info("Initialize class Pay with params: domain: #{domain}, api_id: #{api_id}, api_key: #{api_key}, test: #{test}") if !@logger.nil?
        @token = api_key
        @_auth = {domain: domain, api_id: api_id, api_key: api_key, test: test}
    end
    def pay(amount: , shop: , currency: , system_name: , paid_commission: "shop", number:, tag:, priority:)
        data = {
            amount: amount.to_f, 
            shop: shop, 
            currency: currency,
            system: SYSTEM_IDS[system_name],
            paid_commision: paid_commision,
            number: number, 
            tag: tag, 
            priority: priority
        }
        @logger.info("Pay.pay with data: #{data.inspect}") unless @logger.nil?
        make_request("api_payment",data)
    end
    def balance(shop: ) 
        data = {
            shop: shop,
            api_id: @_auth[:api_id], 
            api_key: @_auth[:api_key]
        }
        @logger.info("Pay.balance with data: #{data.inspect}") unless @logger.nil?
        make_request(
            func: "api_get_shop_balance", 
            data: data, 
            merge_auth: false
        )
    end
    def currency_rate(inn:,out:)
        if !CURRENCIES.include? inn 
            raise "#{inn} not include in currencies: #{CURRENCIES}"
        end
        if !CURRENCIES.include? out 
            raise "#{out} not include in currencies: #{CURRENCIES}"
        end
        data = {
            currency_in: inn, 
            currency_out: out
        }
        @logger.info("Pay.currency_rate with data: #{data.inspect}") if !@logger.nil?
        make_request(
            func: nil,
            data: data,
            merge_auth: false, 
            url: RATE_URL
        )
    end
    private
    def  make_request(func:,data: ,merge_auth: , url: nil)
        data = data.merge({func: func}) if !func.nil?
        data = data.merge(@_auth) if merge_auth
        url = BASE_URL if url.nil?
        @logger.info("private Pay.make_request with params: url: #{url.inspect}, data: #{data.inspect}") unless @logger.nil?
        res = Net::HTTP.post_form(url, data)
        @logger.info("private Pay.make_request: result: #{res.inspect}") unless @logger.nil?
        JSON.parse(res.body).deep_symbolize_keys
    end

end
