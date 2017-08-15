require 'spec_helper'

describe ResellerClub::Domains do

  before do
    ResellerClub.reseller_id = '1234'
    ResellerClub.api_key = 'key'
  end

  describe '.check_availability' do
    let(:domain){ 'example' }

    context 'when checking the availability of a single tld as a string' do
      let(:tlds){ 'com' }

      it 'returns the availability of a given domain' do
        stub_request(:get, "https://test.httpapi.com/api/domains/available.json?api-key=key&auth-userid=1234&domain-name=example&tlds=com").
          to_return(status: 200, body: "{\"example.com\":{\"status\":\"regthroughothers\",\"classkey\":\"domcno\"}}")
        ResellerClub::Domains.check_availability(domain, tlds: tlds)
      end
    end

    context 'when checking the availability of a single domain and single tld as an array' do
      let(:tlds){ ['com'] }

      it 'returns the availability of a given domain' do
        stub_request(:get, "https://test.httpapi.com/api/domains/available.json?api-key=key&auth-userid=1234&domain-name=example&tlds=com").
          to_return(status: 200, body: "{\"example.com\":{\"status\":\"regthroughothers\",\"classkey\":\"domcno\"}}")
        ResellerClub::Domains.check_availability(domain, tlds: tlds)
      end
    end

    context 'when checking the availability of multiple tlds for a single domain' do
      let(:tlds){ ['com', 'net'] }

      it 'returns the status of multiple tlds' do
        stub_request(:get, "https://test.httpapi.com/api/domains/available.json?api-key=key&auth-userid=1234&domain-name=example&tlds=com&tlds=net").
          to_return(status: 200, body: "{\"example.com\":{\"status\":\"regthroughothers\",\"classkey\":\"domcno\"},\"example.net\":{\"status\":\"regthroughothers\",\"classkey\":\"domcno\"}}")
        ResellerClub::Domains.check_availability(domain, tlds: tlds)
      end
    end
  end

  describe '.register' do
    it 'performs a register request' do
      stub_request(:post, "https://test.httpapi.com/api/domains/register.xml?api-key=key&auth-userid=1234").
          with(body: ["domain-name=domain.com", "years=1", "ns=ns1.domain.com", "ns=ns2.domain.com", "customer-id=0", "reg-contact-id=0", "admin-contact-id=0", "tech-contact-id=0", "billing-contact-id=0", "invoice-option=KeepInvoice"]).
          to_return(:status => 200, :body => "{\"actiontypedesc\":\"Registration of domain1400389513.com for 1 year\",\"unutilisedsellingamount\":\"-9.120\",\"sellingamount\":\"-9.120\",\"entityid\":\"54721042\",\"actionstatus\":\"Success\",\"status\":\"Success\",\"eaqid\":\"249100138\",\"customerid\":\"10985610\",\"description\":\"domain1400389513.com\",\"actiontype\":\"AddNewDomain\",\"invoiceid\":\"43430187\",\"sellingcurrencysymbol\":\"USD\",\"actionstatusdesc\":\"Domain registration completed Successfully\"}")
      result = ResellerClub::Domains.register('domain.com', {
        name_servers: %w(ns1.domain.com ns2.domain.com),
        customer_id: 0,
        registrant_contact_id: 0,
        admin_contact_id: 0,
        technical_contact_id: 0,
        billing_contact_id: 0
      })
      # TODO: result.should be_a DomainRegistrationResult
    end
  end

end
