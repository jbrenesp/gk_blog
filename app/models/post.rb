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
    html = body.to_s.gsub(%r{</(p|div|li|h[1-6])>|<br\s*/?>}i, '\0 ')
    fragment = Nokogiri::HTML::DocumentFragment.parse(html)
    fragment.css("action-text-attachment").remove
    fragment.text.gsub("\u00A0", " ").squish
   end
end
