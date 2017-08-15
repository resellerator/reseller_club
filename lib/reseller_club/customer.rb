module ResellerClub
  class Customer
    attr_accessor :id,
                  :status,
                  :name,
                  :username,
                  :email,
                  :address1,
                  :city,
                  :state,
                  :zip,
                  :country,
                  :company

    def initialize(args_hash)
      args_hash.each do |key, value|
        send("#{key}=", value)
      end
    end

    def domains
      Domains.search(customer_id: id)
    end

  end
end
