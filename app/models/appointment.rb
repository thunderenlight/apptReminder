class Appointment < ApplicationRecord

	validates :name, presence: true
	validates :phone_number, presence: true
	validates :time, presence: true

	after_create :reminder

	

	def reminder
		@twilio_number = Rails.application.secrets.TWILIO_NUMBER
		account_sid = Rails.application.secrets.TWILIO_ACCOUNT_SID
		@client = Twilio::REST::Client.new account_sid, Rails.application.secrets.TWILIO_AUTH_TOKEN
		time_str = ((self.time).localtime).strftime("%I:%M%p on %b. %d, %Y")
		time_now = Time.now
		body = "Hi #{self.name}. Just a reminder that you have a new cooking step at #{time_str}. Now It is #{time_now}."
		message = @client.messages.create(
			:from => @twilio_number,
			:to => self.phone_number,
			:body => body
		)
	end


	def when_to_run
		minutes_before_appointment = 2.minutes
		time - minutes_before_appointment
	
	end

	handle_asynchronously :reminder, :run_at => Proc.new { |i| i.when_to_run }
end
