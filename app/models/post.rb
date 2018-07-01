class Post < ApplicationRecord
    belongs_to :category
    belongs_to :user
    validates_presence_of :user_id, :category_id, :title, :expense
    default_scope -> {
        order "created_at DESC"
    }
end
