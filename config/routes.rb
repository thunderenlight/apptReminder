Rails.application.routes.draw do
  resources :appointments 

  	post '/twilio/sms'
  	root 'appointments#new' 
	#post "/helpcenter" => "forums#create", :as => :create_forum
  #root 'appointments#welcome'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
