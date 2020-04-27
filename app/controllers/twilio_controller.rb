class TwilioController < ApplicationController
	skip_before_action :verify_authenticity_token

	def trigger_update
		# @appointment.update(time: new_time)
	end

	def sms
		from = params[:From].gsub(/^\+\d/, '')

		@appointment = Appointment.find_by(name: "twig")
		@appointment.trigger_update
		time = @appointment.time
		str_time = ((time).localtime).strftime("%I:%M%p on %b. %d, %Y")
		user = @appointment.name

		response = Twilio::TwiML::MessagingResponse.new do |r|
			r.message body: "Hey #{user} at #{from} your next reminder is at #{str_time}"
		end
		render xml: response.to_s
	end

end