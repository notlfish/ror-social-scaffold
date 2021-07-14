require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Test validations' do
    it 'user id invalid when there is no password confirmation' do
      user = User.new(name: 'user', email: 'user@example.com', password: '123456')
      expect(user.valid?).to be(false)
    end
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

  describe 'Test associations' do
    before(:each) do
      users = []
      5.times do |n|
        user = User.create(name: "User#{n}",
                           email: "user#{n}@example.com",
                           password: '123456',
                           password_confirmation: '123456')
        users[n] = user
      end
      (1..4).each do |n|
        create_invitation_pair(users[0], users[n], n.even?)
      end
    end

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
      manual_fetch = [user0, user3].map { |user| user.name }
      association_fetch = user2.friends.map { |user| user.name }

      expect(association_fetch).to match_array(manual_fetch)
    end
  end
end
