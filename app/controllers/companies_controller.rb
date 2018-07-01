class CompaniesController < ApplicationController
    before_action :find_company, only: [:destroy, :update, :all_posts, :record]
    before_action :find_user, only: [:add_user, :remove_user]

    def record
    end

    def new
        unless signed_in?
            flash[:danger] = "Please sign in first"
            redirect_to login_path
        end
        @company = Company.new
    end

    def index
        @companies = current_user.companies
    end

    def create
        unless signed_in?
            flash[:danger] = "Please sign in first"
            redirect_to login_path
        else
            @company = Company.new(name: params[:company][:name], creator_id: current_user.id)
            if @company.save
                c = Category.create(name: "Other", icon_id: 8)
                @company.categories << c
                current_user.companies << @company
                redirect_to @company
            else
                render :new
            end
        end
    end

    def show
        @company = Company.find(params[:id])
        @post = Post.new
    end

    def destroy
        begin
            @company = Company.find(params[:id])
        rescue
            flash[:danger] = "Company doesn't exist"
            redirect_to root_path
        ensure
            if @company.destroy!
                flash[:success] = "Deleted successfully"
                redirect_to root_path
            else
                flash[:danger] = "@company.errors.full_messages"
                redirect_to root_path
            end
        end
    end


    def add_user
        if @user.companies.where(id: @company.id).count > 0
            flash[:danger] = "User is already in company"
            redirect_to @company
        else
            @user.companies << @company
            flash[:success] = "Successfully added"
            redirect_to @company
        end
    end

    def remove_user
        if @user.companies.where(id: @company.id).count == 0
            flash[:danger] = "User is not in the Company"
            redirect_to @company
        else
            if @company.creator_id == @user.id
                @company.destroy
                flash[:success] = "Company was destroyed"
                redirect_to @user
            else
                @user.companies.delete(@company)
                flash[:success] = "User was removed from company"
                redirect_to @company
            end
        end
    end
    
    def all_posts
        begin
            @company = Company.find(params[:id])
        rescue
            flash[:danger] = "Company does not exist"
            redirect_to root_path
        ensure
            @all_posts = @company.categories.map{ |x| x.posts}

        end
    end
    private
    
    def find_company
        begin
            @company = Company.find(params[:id])
        rescue
            flash[:danger] = "Company does not exist #{params[:id]}!"
            redirect_to root_path
        ensure
            if !signed_in?
                flash[:danger] = "Please Sign in first"
                redirect_to login_path
            elsif  @company && !(current_user.id == @company.creator_id)
                flash[:danger] = "You cannot change other Companies"
                redirect_to root_path #sosyn
            end
        end
    end

    def find_user
        begin
            @company = Company.find(params[:add_user][:id])
            if !signed_in?
                flash[:danger] = "Please Sign in first"
                redirect_to login_path
            elsif  @company && !(current_user.id == @company.creator_id)
                flash[:danger] = "You cannot change other Companies"
                redirect_to root_path #sosyn
            end
        rescue
            flash[:danger] = "Company does not exist #{params[:add_user][:id]}!"
            redirect_to root_path
        end
        login = params[:add_user][:login]
        if login.include? "@"
            @user=User.find_by_email(login) 
        else 
            @user=User.find_by_username(login)
        end
        unless @user
            flash[:danger] = "User does not exist"
            redirect_to root_path # sosyn ozgertemiz
        end
    end
end
