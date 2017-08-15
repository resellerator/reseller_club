module ResellerClub
  def self.authenticate(username, password)
    begin
      authenticate!(username, password)
    rescue API::Error
      false
    end
  end

  def self.authenticate!(username, password)
    response = API.get('/customers/authenticate.json', query: {
      username: username,
      passwd: password
    })
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

  # Generate an authentication token. Note that token will only be valid for 120 seconds.
  def self.generate_token(username, password, ip_address)
    begin
      generate_token!(username, password, ip_address)
    rescue API::Error
      false
    end
  end

  # Generate an authentication token. Note that token will only be valid for 120 seconds.
  def self.generate_token!(username, password, ip_address)
    API.get('/customers/generate-token.json', query: {
      username: username,
      passwd: password,
      ip: ip_address
    })
  end


  def self.validate_auth_token(token)
    begin
      validate_auth_token!(token)
    rescue API::Error
      false
    end
  end

  def self.validate_auth_token!(token)
    response = API.get('/customers/authenticate-token.json', query: {token: token})
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
