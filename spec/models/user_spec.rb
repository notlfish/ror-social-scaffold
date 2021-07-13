require 'rails_helper'

RSpec.describe User, type: :model do
  describe 'Test validations' do
    it 'user id invalid when there is no password confirmation' do
      user = User.new(name: 'user', email: 'user@example.com', password: '123456')
      expect(user.valid?).to be(false)
    end
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
        Invitation.create(
          user_id: users[0].id,
          friend_id: users[n].id,
          confirmed: n.even?
        )
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

    it 'user is associated to their invited friends' do
      user = User.find_by(name: 'User0')
      expect(user.invited_friends.count).to eq(2)
    end

    it 'user is associated to their inviting friends' do
      user = User.find_by(name: 'User2')
      expect(user.inviter_friends.count).to eq(1)
    end

    it 'dependent objects get destroyed with the user' do
      user = User.find_by(name: 'User0')
      post = user.posts.create(content: 'A jolly good post')
      post_id = post.id
      user.destroy
      expect(Post.find_by(id: post_id)).to eq(nil)
    end
  end
end
