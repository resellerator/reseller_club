require_relative 'customer'

module ResellerClub
  class Customers

    def self.search(page: 1, per_page: 10)
      response = API.get('/customers/search.json', query: {'page-no' => page, 'no-of-records' => per_page})
      # TODO: create a response object which contains the totals
      response.delete 'recsonpage' # current page total
      response.delete 'recsindb'   # total search results

      response.map do |index, data|
        Customer.new({
          id: data['customer.customerid'],
          status: data['customer.customerstatus'],
          name: data['customer.name'],
          username: data['customer.username'],
          city: data['customer.city'],
          country: data['customer.country'],
          company: data['customer.company'],
          # totalreceipts: data['customer.totalreceipts'],
          # reseller_id: data['customer.resellerid'],
          # website_count: data['customer.websitecount'],
        })
      end
    end

    def self.find_by_username(username)
      response = API.get('/customers/details.json', query: {username: username})
      Customer.new({
        id: response['customerid'],
        status: response['customerstatus'],
        name: response['name'],
        username: response['username'],
        email: response['useremail'],
        address1: response['address1'],
        city: response['city'],
        state: response['state'],
        zip: response['zip'],
        country: response['country'],
        company: response['company'],
      })
    end

  end
end
