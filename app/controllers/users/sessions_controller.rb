class Users::SessionsController < Devise::SessionsController
  def create
    respond_to do |format|
      format.html { super }
      format.json do
        warden.authenticate!(scope: resource_name, recall: "#{controller_path}#new")
        render status: 200, json: { message: 'Log in successful' }
      end
    end
  end
end
