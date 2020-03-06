class Answer < ApplicationRecord
  include Votable
  include Commentable
  include Linkable

  has_many :links, as: :linkable, dependent: :destroy
  belongs_to :question, touch: true
  belongs_to :user
  has_one :badge

  accepts_nested_attributes_for :links, reject_if: :all_blank, allow_destroy: true

  has_many_attached :files

  validates :body, presence: true

  after_create :subscription_job

   def best!
    return if best

    Answer.transaction do
      question.answers.update_all
      update!(best: true)
      update!(badge: question.badge) if question.badge
    end
  end

  def subscription_job
    QuestionSubscriptionJob.perform_later(self)
  end
end
