module Doorkeeper
  class AuthorizedApplicationsController < Doorkeeper::ApplicationController
    before_action :authenticate_resource_owner!

    def index
      @applications = Application.authorized_for(current_resource_owner)

      respond_to do |format|
        format.html
        format.json { render json: @applications }
      end
    end

    def destroy
      AccessToken.revoke_all_for params[:id], current_resource_owner

      respond_to do |format|
        format.html do
          redirect_to oauth_authorized_applications_url, notice: I18n.t(
            :notice, scope: %i[doorkeeper flash authorized_applications destroy]
          )
        end

        format.json { render :no_content }
      end
    end
  end
end
