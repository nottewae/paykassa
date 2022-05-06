# frozen_string_literal: true

require_relative "paykassa/version"
require_relative "paykassa/order"
require_relative "paykassa/pay"
module Paykassa
  class Error < StandardError; end
  class Paykassa 
    def initialize(domain:, sci_id:, sci_key:, api_id: nil, api_key: nil, test:)
      @paykassa_order = PaykassaOrder.new({domain: domain, sci_id: sci_id, sci_key: sci_key})
      if api_id.nil? 
        @paykassa_pay = nil
      else
        @paykassa_pay = PaykassaPay.new(
          {
            domain: domain, api_id: api_id, api_key: api_key, test: test
          }
        )
      end
    end
    
    def pay(amount: , shop: , currency: , system_name: , paid_commission: "shop", number:, tag:, priority:)
      raise "api_key not present!" if @paykassa_pay.nil?
      @paykassa_pay.pay({
        amount: amount,
        shop: shop,
        currency: currency,
        system_name: system_name,
        paid_commision: paid_commision,
        number: number,
        tag: tag,
        priority: priority
      })
    end
 
    def balance(shop:)
      raise "api_key not present!" if @paykassa_pay.nil?
      @paykassa_pay.balance(shop: shop)
    end
    def rate(c_in, c_out) 
      @paykassa_pay.currency_rate(c_in, c_out)
    end

    def create_order(amount:, currency:, order_id:, system:, comment: "from paykassa gem")
      order = @paykassa_order.create_order(
        amount: amount, 
        currency: currency, 
        order_id: order_id, 
        comment: comment, 
        system: system
      )
      raise StandardError.new(order[:message]) if order[:error]
      url = order[:data][:url]
    end
    def confirm_order(hash:)
      result = @paykassa_order.confirm_order(hash)
      raise StandardError.new(result[:message]) if result[:error]
      order_id = res[:data][:order_id]
      amount = res[:data][:amount]
      {order_id: order_id, amount: amount}
    end
  end
end
