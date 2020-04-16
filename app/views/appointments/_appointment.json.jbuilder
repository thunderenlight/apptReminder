json.extract! appointment, :id, :name, :phone_number, :time, :created_at, :updated_at
json.url appointment_url(appointment, format: :json)
