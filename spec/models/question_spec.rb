require 'rails_helper'

RSpec.describe Question, type: :model do
  let(:question) { create(:question) }

  it_behaves_like 'votable model'
  it_behaves_like 'commentable model'
  it_behaves_like 'linkable model'

  it { should have_many(:answers).dependent(:destroy).order(best: :desc) }
  it { should have_many(:links).dependent(:destroy) }
  it { should have_one(:badge).dependent(:destroy) }
  it { should belong_to(:user) }
  it { should have_many(:subscriptions).dependent(:destroy) }
  it { should have_many(:subscribed_users).through(:subscriptions).source(:user) }

  it { should validate_presence_of :title }
  it { should validate_presence_of :body }

  it { should accept_nested_attributes_for :links }
  it { should accept_nested_attributes_for :badge }

  it 'have many attached files' do
    expect(Question.new.files).to be_an_instance_of(ActiveStorage::Attached::Many)
  end

  it 'author subscribes by default' do
    expect(question.subscribed_users).to include(question.user)
  end
end
