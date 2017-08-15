module ResellerClub
  class Domain
    attr_accessor :name_with_tld,
                  :available,
                  :customer_id,
                  :order_id,
                  :expires_at,
                  :transfer_lock,
                  :auto_renew,
                  :original_data

    def initialize(name_with_tld, args_hash)
      @name_with_tld = name_with_tld
      args_hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    def name
      @name_with_tld.split('.').first
    end

    def tld
      @name_with_tld.split('.').last
    end

    def available?
      @available == true
    end

    # get current dns information
    # update dns records
  end
end
