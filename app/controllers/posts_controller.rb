class PostsController < ApplicationController
    before_action :check
    before_action :find_post, except: [:create]

    def create
        post = Post.new(user_id: current_user.id, title: params[:post][:title], description: params[:post][:description], expense: params[:post][:expense], category_id: params[:post][:category_id])
        if post.save
            redirect_to company_path(id: @category.company.id)
        else
            flash[:danger] = post.errors.full_messages.first
            redirect_to company_path(id: @category.company.id)
        end
    end
    
    def update
        if @post.update_attributes(post_params)
            render json: @post
        else
            render json: {errors: post.errors.full_messages }, status: :error
        end
    end

    def destroy
        if @post.destroy
            render json: {success: "Deleted Successfully"}
        else
            render json: {errors: @post.errors.full_messages}, status: :error
        end
    end

    def show
        render json: @post
    end

    private
    def post_params
        params.permit(:title, :description, :expense, :category_id)
    end

    def check
        unless signed_in?
            flash[:danger] = "Please Sign in first"
            redirect_to login_path
        end
        if @category = Category.find(params[:category_id])
            if !@category.company.users.exists?(current_user.id)
                flash[:danger] = "You are not in the company"
                redirect_to root_path
            end
        else
            flash[:danger] = "Category doesn't exist"
                redirect_to root_path
        end
    end

    def find_post
        @post = Post.find(params[:id])
        unless @post
            flash[:danger] = "Post doesn't exist"
                redirect_to root_path
        end
    end
end
