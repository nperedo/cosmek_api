module Api
  module V1
    class AppointmentsController < ApplicationController
      before_action :set_appointment, only: [:show, :cancel, :reschedule]

      def index
        appointments = Appointment.all
        render json: appointments, status: :ok
      end

      def show
        render json: @appointment, status: :ok
      end

      def create
        appointment = Appointment.new(appointment_params)
        if appointment.save
          render json: appointment, status: :created
        else
          render json: { errors: appointment.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ActionController::ParameterMissing => e
        render json: { error: e.message }, status: :bad_request
      end

      def cancel
        if @appointment.cancel!
          render json: { message: "Appointment cancelled successfully" }, status: :ok
        else
          render json: { errors: "Unable to cancel appointment" }, status: :unprocessable_entity
        end
      end

      def reschedule
        if @appointment.reschedule!(DateTime.parse(params[:new_time]))
          render json: @appointment, status: :ok
        else
          render json: { errors: @appointment.errors.full_messages }, status: :unprocessable_entity
        end
      rescue ArgumentError
        render json: { error: "Invalid time format" }, status: :unprocessable_entity
      end

      def find
        customer = Customer.find_by(
          name: params[:name],
          email: params[:email],
          phone: params[:phone]
        )
        if customer
          appointments = customer.appointments.includes(:stylist)
          render json: appointments, status: :ok
        else
          render json: [], status: :ok
        end
      end

      private

      def set_appointment
        @appointment = Appointment.find(params[:id])
      rescue ActiveRecord::RecordNotFound
        render json: { error: "Appointment not found" }, status: :not_found
      end

      def appointment_params
        params.require(:appointment).permit(:time, :duration, :customer_id, :stylist_id, :status)
      end
    end
  end
end

