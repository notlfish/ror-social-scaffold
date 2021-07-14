class InvitationsController < ApplicationController
  def create
    invitations = [Invitation.new(user_id: params[:user],
                                  friend_id: params[:friend],
                                  confirmed: false,
                                  inviter_id: params[:user]),
                   Invitation.new(user_id: params[:friend],
                                  friend_id: params[:user],
                                  confirmed: false,
                                  inviter_id: params[:user])]
    if invitations.all?(&:save)
      redirect_to User.find(invitations[0].friend_id),
                  notice: 'Your friendship invitation was successfully sent.'
    else
      render :back, alert: invitations.reduce do |acc, inv|
        acc + inv.errors.full_messages
      end
    end
  end

  ## Accepting the invitation
  def update
    invitations = fetch_invitations(params[:id])
    invitations.each { |inv| inv.confirmed = true }

    if invitations.all?(&:save)
      redirect_to user, notice: 'You now have one more friend!'
    else
      render current_user, alert: invitations.reduce do |acc, inv|
        acc + inv.errors.full_messages
      end
    end
  end

  def destroy
    invitations = fetch_invitations(params[:id])
    invitations.each(&:destroy)
    redirect_to current_user, notice: 'Invitation successfully rejected.'
  end

  private

  def fetch_invitations(example_id)
    from_invitation = Invitation.find(example_id)
    from_id = from_invitation.user_id
    to_id = from_invitation.friend_id
    Invitation.between(from_id, to_id)
  end
end
