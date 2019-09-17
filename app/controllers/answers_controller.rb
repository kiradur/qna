class AnswersController < ApplicationController
  include Voted

  before_action :authenticate_user!, except: %i[index show]
  after_action :publish_answer, only: :create

  helper_method :question

  expose :answers, from: :question
  expose :answer, scope: -> { Answer.with_attached_files }
  expose :comment, -> { answer.comments.new }

  def create
    authorize! :create, Answer
    question.answers << answer
    answer.user = current_user
    answer.save
  end

  def destroy
    authorize! :destroy, answer
    answer.destroy if current_user.author_of?(answer)
  end

  def update
    authorize! :update, answer
    answer.update(answer_params) if current_user.author_of?(answer)
  end

  def best
    authorize! :best, answer
    answer.best! if current_user.author_of?(question)
  end

  private

  def publish_answer
    return if answer.errors.any?

    AnswersChannel.broadcast_to(
      answer.question,
      answer: answer,
      links: answer.links,
      files: answer.files.map { |file| { id: file.id, name: file.filename.to_s, url: url_for(file) } }
    )
  end

  def question
    Question.find_by(id: params[:question_id]) || answer.question
  end

  def answer_params
    params.require(:answer).permit(:body, files: [], links_attributes: [:id, :name, :url, :_destroy])
  end
end
