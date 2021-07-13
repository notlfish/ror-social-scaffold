class User < ApplicationRecord
  # Include default devise modules. Others available are:
  # :confirmable, :lockable, :timeoutable, :trackable and :omniauthable
  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :validatable

  validates :name, presence: true, length: { maximum: 20 }
  validates :password_confirmation, presence: true

  has_many :posts, dependent: :destroy
  has_many :comments, dependent: :destroy
  has_many :likes, dependent: :destroy

  has_many :invitations, dependent: :destroy

  has_many :invitations_sent_confirmed, -> { where confirmed: true },
           class_name: 'Invitation'
  has_many :invited_friends, through: :invitations_sent_confirmed,
           source: :friend, class_name: 'User'

  has_many :pending_invitations, -> { where confirmed: false },
           class_name: 'invitation', foreign_key: 'friend_id'
  has_many :invitations_received_confirmed, -> { where confirmed: true },
           class_name: 'Invitation', foreign_key: 'friend_id'
  has_many :inviter_friends, through: :invitations_received_confirmed,
           source: :user, class_name: 'User'


  def friends
    friends_sent_invitation = Invitation.where(user_id: id, confirmed: true).pluck(:friend_id)
    friends_got_invitation = Invitation.where(friend_id: id, confirmed: true).pluck(:user_id)

    ids = friends_sent_invitation + friends_got_invitation
    User.where(id: ids)
  end

  def friend_with?(user)
    invitation.confirmed_record?(id, user.id)
  end

  def pending_invitations
    Invitation.where(friend_id: id, confirmed: false)
  end

  def invitable?(user)
    case1 = Invitation.where(user_id: id, friend_id: user.id).empty?
    case2 = Invitation.where(user_id: user.id, friend_id: id).empty?
    case1 && case2 && id != user.id
  end
end
