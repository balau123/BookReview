class Book < ApplicationRecord
  belongs_to :user
  belongs_to :category
  has_many :reviews

  has_many :tags
  accepts_nested_attributes_for :tags, reject_if: :all_blank, allow_destroy: true

  has_attached_file :book_img, styles: { book_index: "250x350>", book_show: "325x475>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :book_img, content_type: /\Aimage\/.*\z/

end
123456