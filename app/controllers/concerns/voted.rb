module Voted
  extend ActiveSupport::Concern

  def vote_up
    authorize! :vote_up, @votable
    @votable.vote_up(current_user)
    respond_to do |format|
      format.json do
        if vote.nil? || vote.save
          render json: { object_id: @votable.id, value: @votable.rating, model: @votable.class.name.underscore }
        else
          render json: vote.errors, status: :unprocessable_entity
        end
      end
    end
  end

  def vote_down
    authorize! :vote_down, @votable
    @votable.vote_down(current_user)
    respond_to do |format|
      format.json do
        if vote.nil? || vote.save
          render json: { object_id: @votable.id, value: @votable.rating, model: @votable.class.name.underscore }
        else
          render json: vote.errors, status: :unprocessable_entity
        end
      end
    end
  end

  private

  def votable
    @votable = controller_name.singularize
  end
end
