class CategoriesController < ApplicationController
    before_action :check, except: [:show]
    before_action :find_category, except: [:create]
    
    def create
        @category = Category.new(name: params[:name], icon_id: params[:icon_id], company_id: @company.id)
        if @category.save
            render json: @category, only: [:name, :company_id, :icon_id], include: {posts: {except: [:category_id]}}
        else
            render json: {errors: @category.errors.full_messages}, status: :error
        end
    end
    
    def destroy
        if @category.destroy
            render json: {success: "Deleted Successfully"}
        else
            render json: {errors: @category.errors.full_messages}, status: :error
        end
    end
    
    def update
        if @category.update_attributes(name: params[:name], icon_id: params[:icon_id])
            render json: {success: "Updated Successfully"}
        else
            render json: {errors: @category.errors.full_messages}, status: :error
        end
    end
    
    def show
        render json: @category, only: [:name, :company_id, :icon_id], include: {posts: {except: [:category_id]}}
    end
    
    private
    
    def check
        unless signed_in?
            render json: {errors: "Please Sign in first"}, status: :error
        end
        if @company = Company.find(params[:company_id])
            if !@company.users.exists?(current_user.id)
                render json: {errors: "You are not in the company"}, status: :error
            end
        else
            render json: {errors: "Company does not exist"}, status: :error
        end
    end
    
    def find_category
        begin
            @category = Category.find(params[:id])
        rescue
            render json: {errors: "Category does not exist"}, status: :error
        end
    end
    
end
    