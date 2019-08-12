class BadgesController < ApplicationController
  expose :user
  expose :badges, -> { user.badges }

  def index; end
end
