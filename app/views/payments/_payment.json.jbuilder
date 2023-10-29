json.extract! payment, :id, :amount, :brand, :created_at, :updated_at
json.url payment_url(payment, format: :json)
