module Votable
  extend ActiveSupport::Concern

  included do
    has_many :votes, as: :votable, dependent: :destroy
  end

  def vote_up(user)
    vote(1, user)
  end

  def vote_down(user)
    vote(-1, user)
  end

  def destroy_if_revote(vote)
    return vote unless vote.value.zero?

    vote.destroy
  end

  def rating
    votes.sum(:value)
  end

  private

  def vote(value, user)
    vote = votes.where(user: user, value: value).first  

    if vote
      vote.destroy
    else
      votes.create(score: score, user: user)
    end  
  end 
end
