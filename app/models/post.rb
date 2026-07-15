class Post < ApplicationRecord
    belongs_to :user
    enum :status, { draft: 0, pending: 1, published: 2 }
    has_many_attached :images
    has_many :likes, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_rich_text :body

    def preview_image
      body.embeds.first
    end

    def plain_excerpt
        fragment = Nokogiri::HTML::DocumentFragment.parse(body.to_s)
        fragment.css("action-text-attachment").remove
        ActionView::Base.full_sanitizer.sanitize(fragment.to_html).squish
        CGI.unescapeHTML(text)
    end
end
