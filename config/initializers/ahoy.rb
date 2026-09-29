class Ahoy::Store < Ahoy::DatabaseStore
  def exclude?
    # The login page is excluded too: admins aren't signed in yet when they load it
    super || (user && user.admin?) || controller.is_a?(Devise::SessionsController)
  end
end

Ahoy.cookies = true

# Ahoy cookies are only set once the visitor accepts the cookie banner.
# Until then (or after declining) visits are still tracked, without cookies,
# by grouping requests with the same masked IP and user agent.
module AnalyticsConsent
  def cookies?
    super && Current.analytics_cookies == true
  end
end
Ahoy.singleton_class.prepend(AnalyticsConsent)

# store 1.2.3.0 instead of 1.2.3.4
Ahoy.mask_ips = true

# set to true for JavaScript tracking
Ahoy.api = false

# set to true for geocoding (and add the geocoder gem to your Gemfile)
Ahoy.geocode = false
