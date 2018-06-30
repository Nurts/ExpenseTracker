class PostsController < ApplicationController
    before_action :check
    before_action :find_post, except: [:create]

    def create
        post = Post.new(user_id: current_user.id, title: params[:title], description: params[:description], expense: params[:expense], category_id: params[:category_id])
        if post.save
            render json: post
        else
            render json: {errors: post.errors.full_messages }, status: :error
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
            render json: {errors: "Please Sign in first"}, status: :error
        end
        if @category = Category.find(params[:category_id])
            if !@category.company.users.exists?(current_user.id)
                render json: {errors: "You are not in the company"}, status: :error
            end
        else
            render json: {errors: "Category does not exist"}, status: :error
        end
    end

    def find_post
        @post = Post.find(params[:id])
        unless @post
            render json: {errors: "Post does not exist"}, status: :error 
        end
    end
end
