class Post < ApplicationRecord
    belongs_to :user
    enum :status, { draft: 0, pending: 1, published: 2}
end
