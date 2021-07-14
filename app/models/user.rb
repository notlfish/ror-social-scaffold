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
  has_many :liked_posts, through: :likes, source: :post

  has_many :invitations, dependent: :destroy

  has_many :invitations_confirmed, -> { where confirmed: true },
           class_name: 'Invitation'
  has_many :friends, through: :invitations_confirmed, source: :friend

  has_many :pending_invitations, -> { where confirmed: false },
           class_name: 'invitation', foreign_key: 'friend_id'

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
