class Ahoy::Store < Ahoy::DatabaseStore
  def exclude?
    # The login page is excluded too: admins aren't signed in yet when they load it
    super || (user && user.admin?) || controller.is_a?(Devise::SessionsController)
  end
end

Ahoy.cookies = true

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
Ahoy.geocode = false
