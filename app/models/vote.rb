class Vote < ApplicationRecord
  belongs_to :user
  belongs_to :votable, polymorphic: true

  validates :value, inclusion: { in: [-1, 1], message: "You can't vote twice" }

  validate :author_cant_vote

  private

  def author_cant_vote
    errors.add(:user, "Author can't vote") if user&.author_of?(votable)
  end
end
