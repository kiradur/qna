class User < ApplicationRecord
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable,
         :omniauthable, omniauth_providers: [:github]
         
  has_many :questions, dependent: :destroy
  has_many :answers, dependent: :destroy
  has_many :badges, through: :answers
  has_many :votes, dependent: :destroy
  has_many :authorizations, dependent: :destroy
  has_many :subscriptions, dependent: :destroy

  def author?(object)
    object.user_id == self.id
  end

  def self.find_for_oauth(auth)
    Services::FindForOauth.new(auth).call
  end

  def create_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid)
  end

  def create_unconfirmed_authorization(auth)
    authorizations.create(provider: auth.provider, uid: auth.uid, confirmation_token: Devise.friendly_token)
  end

  def generate_password
    new_password = Devise.friendly_token
    self.password = self.password_confirmation = new_password
    self
  end

  def auth_confirmed?(auth)
    auth && authorizations.find_by(uid: auth.uid, provider: auth.provider)&.confirmed?
  end

  def subscribed?(question)
    !!subscription(question)
  end

  def subscription(question)
    subscriptions.find_by(question_id: question.id)
  end
end
