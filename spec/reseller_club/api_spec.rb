require 'spec_helper'

describe ResellerClub::API do
  describe '.get' do
    context 'when API settings are blank' do
      it 'raises an exception' do
        ResellerClub.reseller_id = nil
        ResellerClub.api_key = nil
        expect { ResellerClub::API.get('/anything') }.to raise_error ResellerClub::API::Error, 'Missing API Configuration Settings'
        
        ResellerClub.reseller_id = 'something'
        expect { ResellerClub::API.get('/anything') }.to raise_error ResellerClub::API::Error, 'Missing API Configuration Settings'

        ResellerClub.api_key = 'something'
        # TODO: figure out how to test that it does not raise error
        # expect { ResellerClub::API.get('/anything') }.to raise_error ResellerClub::API::Error, 'Missing API Configuration Settings'
      end
    end
  end
end
