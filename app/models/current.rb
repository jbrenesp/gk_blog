class Current < ActiveSupport::CurrentAttributes
  # True when the visitor accepted the cookie banner; Ahoy only sets cookies then.
  attribute :analytics_cookies
end
