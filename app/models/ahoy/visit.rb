class Ahoy::Visit < ApplicationRecord
  self.table_name = "ahoy_visits"

  has_many :events, class_name: "Ahoy::Event"
  belongs_to :user, optional: true

  # Visits whose browser ran JavaScript and reported a page view: real people, not bots
  scope :with_page_views, -> { where(id: Ahoy::Event.where(name: Ahoy::Event::PAGE_VIEW).select(:visit_id)) }
end
