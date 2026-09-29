class Ahoy::Store < Ahoy::DatabaseStore
  def exclude?
    super || (user && user.admin?)
  end
end

Ahoy.cookies = true

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
Ahoy.geocode = false
