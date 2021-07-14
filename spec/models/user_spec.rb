require 'rails_helper'

RSpec.describe User, type: :model do
  def create_post(user)
    user.posts.create(content: "Hello, I'm #{user.name}")
  end

  def create_invitation_pair(inviter, invitee, confirmed)
    Invitation.create(
      user_id: inviter.id,
      friend_id: invitee.id,
      confirmed: confirmed,
      inviter_id: inviter.id
    )
    Invitation.create(
      user_id: invitee.id,
      friend_id: inviter.id,
      confirmed: confirmed,
      inviter_id: inviter.id
    )
  end

  before(:each) do
    users = []
    5.times do |n|
      user = User.create(name: "User#{n}",
                         email: "user#{n}@example.com",
                         password: '123456',
                         password_confirmation: '123456')
      create_post(user)
      users[n] = user
    end
    (1..4).each do |n|
      create_invitation_pair(users[0], users[n], n.even?)
    end
  end

  describe 'Test validations' do
    it 'user id invalid when there is no password confirmation' do
      user = User.new(name: 'user', email: 'user@example.com', password: '123456')
      expect(user.valid?).to be(false)
    end
  end

  describe 'Test associations' do
    it 'user is associated to their sent invitations' do
      user = User.find_by(name: 'User0')
      expect(user.invitations.count).to eq(4)
    end

    it 'user is associated to their received invitations' do
      user = User.find_by(name: 'User1')
      expect(user.pending_invitations.count).to eq(1)
    end

    it 'dependent objects get destroyed with the user' do
      user = User.find_by(name: 'User0')
      post = user.posts.create(content: 'A jolly good post')
      post_id = post.id
      user.destroy
      expect(Post.find_by(id: post_id)).to eq(nil)
    end

    it 'user is associated to all of their friends' do
      user2 = User.find_by(name: 'User2')
      user3 = User.find_by(name: 'User3')
      create_invitation_pair(user2, user3, true)

      user0 = User.find_by(name: 'User0')
      manual_fetch = [user0, user3].map(&:name)
      association_fetch = user2.friends.map(&:name)

      expect(association_fetch).to match_array(manual_fetch)
    end
  end

  describe 'Instance methods' do
    it 'user can be invited' do
      user1 = User.find_by(name: 'User1')
      user2 = User.find_by(name: 'User2')

      expect(user1.invitable?(user2)).to be(true)
    end

    it "user can't be invited -- pending" do
      user0 = User.find_by(name: 'User0')
      user1 = User.find_by(name: 'User1')

      expect(user0.invitable?(user1)).to be(false)
    end

    it "user can't be invited -- friend" do
      user0 = User.find_by(name: 'User0')
      user2 = User.find_by(name: 'User2')

      expect(user0.invitable?(user2)).to be(false)
    end

    it 'show posts relevant to User0' do
      user0 = User.find_by(name: 'User0')

      messages = ["Hello, I'm User4", "Hello, I'm User2", "Hello, I'm User0"]
      fetched_messages = user0.relevant_posts.map(&:content)

      expect(fetched_messages).to eq(messages)
    end
  end
end
