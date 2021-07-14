require 'rails_helper'

def new_invitation(user, friend, confirmed, inviter)
  Invitation.new(
    user_id: user.id,
    friend_id: friend.id,
    confirmed: confirmed,
    inviter_id: inviter.id
  )
end

RSpec.describe Post, type: :model do
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
      new_invitation(users[0], users[n], n.even?, users[0]).save
      new_invitation(users[n], users[0], n.even?, users[0]).save
    end
  end

  describe 'Validations' do
    it "Can't create more than one invitation with the same user and friend" do
      user0 = User.find_by(name: 'User0')
      user1 = User.find_by(name: 'User1')
      repeated = new_invitation(user0, user1, false, user0)
      expect(repeated.valid?).to be(false)
    end
  end

  describe 'Scopes' do
    it 'between fetches the correct invitations' do
      user0_id = User.find_by(name: 'User0').id
      user1_id = User.find_by(name: 'User1').id
      scope_fetch = Invitation.between(user0_id, user1_id).to_a
      p scope_fetch
      manual_fetch = [Invitation.find_by(user_id: user0_id, friend_id: user1_id),
                      Invitation.find_by(user_id: user1_id, friend_id: user0_id)]

      expect(scope_fetch).to match_array(manual_fetch)
    end
  end
end
