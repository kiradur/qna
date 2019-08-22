class BadgesController < ApplicationController
  expose :user
  expose :badges, -> { user.badges }

  def index
    authorize! :index, Badge
  end
end
