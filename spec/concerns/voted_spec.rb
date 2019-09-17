shared_examples_for "voted" do  
  let(:user)          { create(:user) }
  let(:other_user)    { create(:user) }
 

  def send_request(action, member)
    process action, method: :post, params: { id: member }, format: :js
  end

  describe 'POST #vote_up' do  
    context 'resource non-owner' do
      before { login(other_user) }
      
      it 'assigns requested votable resource to @votable' do     
        send_request(:vote_up, user_resource)
        expect(assigns(:votable)).to eq(user_resource)
      end    

      it 'increase score by 1' do
        send_request(:vote_up, user_resource)
        expect(user_resource.rate).to eq(1)
      end

      it 'responds with json' do
        send_request(:vote_up, user_resource)
        expect(response.content_type).to eq('application/json')
      end
    end    

    context 'resource owner' do
      before { login(user) }

      it 'dont save to db' do
        send_request(:vote_up, user_resource)
        expect { send_request(:vote_up, user_resource) }.to_not change(Vote, :count)
      end   

      it 'responds with json' do
        send_request(:vote_up, user_resource)
        expect(response.content_type).to eq('application/json')
      end
    end
  end 

  describe 'POST #votedown' do  
    context 'resource non-owner' do
      before { login(other_user) }
  
      it 'assigns requested votable resource to @votable' do
        send_request(:vote_down, user_resource)
        expect(assigns(:votable)).to eq(user_resource)
      end    

      it 'increase score by -1' do
        send_request(:vote_down, user_resource)
        expect(user_resource.rate).to eq(-1)
      end

      it 'responds with json' do
        send_request(:vote_down, user_resource)
        expect(response.content_type).to eq('application/json')
      end
    end    

    context 'resource owner' do
      before { login(user) }

      it 'assigns requested votable resource to @votable' do
        send_request(:vote_down, user_resource)
        expect(assigns(:votable)).to eq(user_resource)
      end   

      it 'dont save to db' do
        send_request(:vote_down, user_resource)
        expect { send_request(:vote_down, user_resource) }.to_not change(Vote, :count)
      end   

      it 'responds with json' do
        send_request(:vote_down, user_resource)
        expect(response.content_type).to eq('application/json')
      end
    end
  end  
end
