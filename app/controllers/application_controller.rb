class ApplicationController < ActionController::Base
    # protect_from_frogery with: exception

    def current_user
        User.find_by(id: session[:user_id])
    end

    helper_method :current_user

end
