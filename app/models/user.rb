class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable
         
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badges, through: :answers
  has_many :votes, dependent: :destroy

  def author?(object)
    object.user_id == self.id
  end

end
