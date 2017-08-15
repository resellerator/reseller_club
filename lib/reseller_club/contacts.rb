require_relative 'contact'

module ResellerClub
  class Contacts

    def self.search(customer_id:, page: 1, per_page: 10)
      response = API.get('/contacts/search.json', query: {'customer-id' => customer_id, 'page-no' => page, 'no-of-records' => per_page})
      # TODO: create a response object which contains the totals
      response.delete 'recsonpage' # current page total
      response.delete 'recsindb'   # total search results
      response['result'].map do |data|
        ap data
        Contact.new({
          id: data['entity.entityid'],
          name: data['contact.name'],
          company: data['contact.company'],
          email: data['contact.emailaddr'],
          city: data['contact.city'],
          country: data['contact.country'],
        })
      end
    end

  end
end
