class UsersController < ApplicationController
    before_action :correct_user, only: [:update, :destroy, :edit]
    
    def new
        redirect_to root_path if signed_in?
        @user = User.new
    end

    def index
        @users = User.all
    end

    def show
        begin
            @user = User.find(params[:id])
            if @user.companies.count > 0
                @post = Post.new
                @company = @user.companies.first
            end
        rescue
            flash[:danger] = "User doesn't exist"
            redirect_to root_path
        end
    end

    def create
        @user = User.new(user_params)
        puts user_params
        if @user.save
            c = Company.new(name: "#{@user.username}-private", creator_id: @user.id)
            sign_in(@user)
            @user.companies << c
            redirect_to @user
        else
            render :new
        end
    end

    def edit
        @user = User.find(params[:id])
    end

    def update
        begin
            @user = User.find(params[:id])
        rescue
            flash[:danger] = "User doesn't exist"
            redirect_to root_path
        ensure
            if @user.update_attributes(user_params)
                redirect_to @user
            else
                render :new
            end
        end
    end

    def destroy
        begin
            @user = User.find(params[:id])
        rescue
            flash[:danger] = "User doesn't exist"
            redirect_to root_path
        ensure
            Company.where(creator_id: @user.id).destroy_all
            sign_out

            if @user.destroy!
                flash[:success] = "Deleted successfully"
                redirect_to root_path
            else
                flash[:danger] = "Problems occured"
                redirect_to root_path
            end
        end
    end

    private
    def user_params
		params.require(:user).permit(:username, :email, :password, :password_confirmation)
    end
    
    def correct_user
        unless signed_in?
            flash[:danger] = "Please Sign in first"
            redirect_to login_path
        else
            @user = User.find(params[:id])
            unless current_user?(@user.id)
                flash[:danger] = "Not allowed"
                redirect_to root_path
            end
        end
    end
    
end
