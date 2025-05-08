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
        render json: { error: 'Stylist not found' }, status: :not_found
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
        duration = params[:duration].to_i
        slots = stylist.available_slots(date, duration)
        render json: { available_slots: slots }
      rescue ActiveRecord::RecordNotFound
        render json: { error: 'Stylist not found' }, status: :not_found
      rescue ArgumentError
        render json: { error: 'Invalid date format' }, status: :bad_request
      end

      private

      def stylist_params
        params.require(:stylist).permit(:name, :email)
      end
    end
  end
end




