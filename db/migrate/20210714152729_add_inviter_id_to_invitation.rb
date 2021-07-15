class AddInviterIdToInvitation < ActiveRecord::Migration[5.2]
  def change
    add_column :invitations, :inviter_id, :integer, null: false
  end
end
