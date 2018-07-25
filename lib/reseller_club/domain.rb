module ResellerClub
  class Domain
    attr_accessor :name,
                  :available,
                  :customer_id,
                  :order_id,
                  :expires_at,
                  :transfer_lock,
                  :auto_renew,
                  :original_data

    def initialize(**args_hash)
      args_hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    def expires_at=(value)
      @expires_at = Time.at(value.to_i)
    end

    def tld
      name.split('.').last
    end

    def available?
      @available == true
    end

    # get current dns information
    # update dns records
  end
end
