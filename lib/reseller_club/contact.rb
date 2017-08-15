module ResellerClub
  class Contact
    attr_accessor :id,
                  :status,
                  :name,
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

  end
end
