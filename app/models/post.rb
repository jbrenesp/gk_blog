class Post < ApplicationRecord
    belongs_to :user
    enum :status, { draft: 0, pending: 1, published: 2 }
    has_many_attached :images
    has_many :likes, dependent: :destroy
    has_many :comments, dependent: :destroy
    has_rich_text :body
end
