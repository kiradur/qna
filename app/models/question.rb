class Question < ApplicationRecord
  include Votable
  include Commentable
  include Linkable

  has_many :answers, -> { order(best: :desc) }, dependent: :destroy
  has_many :links, as: :linkable, dependent: :destroy
  belongs_to :user
  has_one :badge

  has_many_attached :files

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true
  accepts_nested_attributes_for :badge, reject_if: :all_blank, allow_destroy: true

  validates :title, :body, presence: true
end
