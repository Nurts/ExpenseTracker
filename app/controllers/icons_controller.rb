class IconsController < ApplicationController
    def create
        icon = Icon.new(url: params[:url])
        if icon.save
            render json: icon, only: [:id, :url]
        else
            render json: {errors: icon.errors.full_messages}, status: :error
        end
    end

    def destroy
        if icon = Icon.find(params[:id])
            icon.destroy
            render json: {success: "Deleted successfully"}
        else
            render json: {errors: "Icon does not exist"}, status: :error
        end
    end

    def show
        if icon = Icon.find(params[:id])
            render json: icon, only: [:id, :url]
        else
            render json: {errors: "Icon does not exist"}, status: :error
        end
    end

    def index
        render json: Icon.all, only: [:id, :url] 
    end

end
