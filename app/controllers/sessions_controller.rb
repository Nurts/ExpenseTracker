class SessionsController < ApplicationController
    
    def new
    end

    def omniauth_create
        user = User.from_omniauth(request.env["omniauth.auth"])
        sign_in user
        remember user
        if user.companies.count == 0
            c = Company.new(name: "#{user.username}-private", creator_id: user.id)
            user.companies << c
        end
        redirect_to user
    end
    
    def create
        login = session_params[:login]
        if login.include? "@"
            user=User.find_by_email(login.lowercase) 
        else 
            user=User.find_by_username(login)
        end
    
        if user && user.authenticate(session_params[:password])
            sign_in user
            remember user
            redirect_to user
        else
            flash[:danger] = "Invalid username, email or password"
            render :new
        end
    end
    
    def destroy
        sign_out if signed_in?
        redirect_to root_path
    end

    private

    def session_params
        params.require(:session).permit(:login, :password)
    end
    
end
