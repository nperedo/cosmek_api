module Api
  module V1
    class StylistsController < ApplicationController
      def index
        stylists = Stylist.all
        render json: stylists
      end
      
      def show
        stylist = Stylist.find(params[:id])
        render json: stylist
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Stylist not found" }, status: :not_found
      end
      
      def create
        stylist = Stylist.new(stylist_params)
        
        if stylist.save
          render json: stylist, status: :created
        else
          render json: { errors: stylist.errors.full_messages }, status: :unprocessable_entity
        end
      end
      
      def availability
        stylist = Stylist.find(params[:id])
        date = Date.parse(params[:date])
        duration = params[:duration].present? ? params[:duration].to_i : 60
        
        slots = stylist.available_slots_on(date, duration)
        
        render json: { available_slots: slots }
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Stylist not found" }, status: :not_found
      rescue Date::Error
        render json: { error: "Invalid date format" }, status: :unprocessable_entity
      end
      
      private
      
      def stylist_params
        params.permit(:stylist, :name, :email)
      end
    end
  end
end


