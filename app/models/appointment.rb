class Appointment < ApplicationRecord

	validates :name, presence: true
	validates :phone_number, presence: true
	validates :time, presence: true

	after_save :reminder
	

	def credentials
		@twilio_number = Rails.application.secrets.TWILIO_NUMBER
		account_sid = Rails.application.secrets.TWILIO_ACCOUNT_SID
		auth_token = Rails.application.secrets.TWILIO_AUTH_TOKEN
		@client = Twilio::REST::Client.new account_sid, auth_token
	end


	def reminder
		credentials()
		time_str = ((self.time).localtime).strftime("%I:%M%p on %b. %d, %Y")
		time_now = Time.now
		body = "Hi #{self.name}. Just a reminder that you have a new cooking step at #{time_str}.
				When ready, reply with a number for how many needed to set reminder."
		message = @client.messages.create(
			:from => @twilio_number,
			:to => self.phone_number,
			:body => body
		)
	end

	def preset(arg)
		#case if bread gives you 3 time slots for.each step.new or
		#reminder.new or send 3 appointments by slots =3 until slots = 0
		#they have their own time if cookies time slot1 = 2hrs, 

	end
	def msgs
		credentials()
		@next_time = [] 	
		@messages = @client.messages.list(
        #date_sent: Date.new(2020, 4, 21),
        from: self.phone_number
		)
		@messages.each do |rec|
			@next_time << rec.body
			
		end
		return @next_time
	end

 	def update_reminder() 
 		#if from self and contains a number updatez
 		@new_time = msgs.first
 		#what time
 		#self.update(params[:time], @new_time)
 		#puts @reset_time
 		
 	end

 	def trigger_update
 		min = update_reminder.to_i
 		advance = Time.new.advance(minutes: min)
 		self.update_attributes!(time: advance)
 		return self.time
 	end

	def when_to_run
		minutes_before_appointment = 2.minutes
		time - minutes_before_appointment
	
	end

	def sms
		body = "howdy y'all"
		response = Twilio::TwiML::MessagingResponse.new do |r|
			r.message body: body
		end
	end



	

	handle_asynchronously :reminder, :run_at => Proc.new { |i| i.when_to_run }
end
