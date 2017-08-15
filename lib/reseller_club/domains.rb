require_relative 'domain'

module ResellerClub
  class Domains

    def self.check_availability(domain_without_tld, tlds: ['com'])
      params = {
        'domain-name' => domain_without_tld,
        'tlds' => tlds
      }
      response = API.get('/domains/available.json?' + URI.encode_www_form(params))
      response.map do |domain, information|
        Domain.new(domain, available: information['status'] == 'available')
      end
    end

    def self.register(domain_with_tld, years: 1, name_servers: ['ns1.example.com'], customer_id:, registrant_contact_id:, admin_contact_id:, technical_contact_id:, billing_contact_id:, invoice_option: 'KeepInvoice', purchase_privacy: false, domain_privacy: false)
      unless ['NoInvoice', 'PayInvoice', 'KeepInvoice'].include? invoice_option
        raise 'Invalid Invoice Option'
      end

      response = API.post('/domains/register.json?' + URI.encode_www_form({
        'domain-name' => domain_with_tld,
        'years' => years,
        'ns' => name_servers,
        'customer-id' => customer_id,
        'reg-contact-id' => registrant_contact_id,
        'admin-contact-id' => admin_contact_id,
        'tech-contact-id' => technical_contact_id,
        'billing-contact-id' => billing_contact_id,
        'invoice-option' => invoice_option
      }))
      # TODO: return a registration result object

    end

    def self.all
      search
    end

    # List all domains owned by a specific customer.
    def self.search(page: 1, per_page: 10, order_by: 'orderid', customer_id: nil)
      params = {'page-no' => page, 'no-of-records' => per_page, 'order-by' => order_by}
      params['customer-id'] = customer_id if customer_id
      response = API.get('/domains/search.json', query: params)
      # TODO: create a PaginatableResponse object which contains the totals
      response.delete 'recsonpage' # current page total
      response.delete 'recsindb'   # total search results
      response.map do |index, data|
        Domain.new(data['entity.description'], {
          customer_id: data['entity.customerid'],
          order_id: data['orders.orderid'],
          expires_at: Time.at(data['orders.endtime'].to_i),
          transfer_lock: data['orders.transferlock'],
          auto_renew: data['orders.autorenew'],
          original_data: data
        })
      end
    end

  end
end
