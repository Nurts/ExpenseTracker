class CategoriesController < ApplicationController
    before_action :check, except: [:show]
    before_action :find_category, except: [:create, :new, :index]
    
    def index
        @categories = @company.categories.all
    end

    def new
        @category = Category.new
    end

    def create
        puts params[:categories][:icon_id]
        @category = Category.new(name: params[:category][:name], icon_id: params[:categories][:icon_id], company_id: @company.id)
        if @category.save
            flash[:success] = "Category created successfully"
            redirect_to company_path(id: @company.id)
        else
            render :new
        end
    end
    
    def destroy
        if @category.destroy
            flash[:success] = "Deleted Successfully"
            redirect_to @company
        else
            flash[:danger] = "Something went wrong"
            redirect_to company_category_path(id: @category.id)
        end
    end
    
    def show
    end
    
    private
    
    def check
        unless signed_in?
            flash[:danger] = "Please Sign in first"
            redirect_to login_path
        end
        if @company = Company.find(params[:company_id])
            if !@company.users.exists?(current_user.id)
                flash[:danger] = "You are not in this company!"
                redirect_to user_path(id: current_user.id)
            end
        else
            flash[:danger] = "Company doesn't exist"
            redirect_to root_path
        end
    end
    
    def find_category
        begin
            @category = Category.find(params[:id])
        rescue
            flash[:danger] = "Category doesn't exist"
            redirect_to root_path
        end
    end
    
end
    