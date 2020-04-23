class TwilioController < ApplicationController
	skip_before_action :verify_authenticity_token

	def trigger_update
		# @appointment.update(time: new_time)
	end

	def sms
		body = Appointment.last.id
		response = Twilio::TwiML::MessagingResponse.new do |r|
			r.message body: body
		end
		render xml: response.to_s
	end

end