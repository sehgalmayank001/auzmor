class Account < ApplicationRecord
  self.table_name = 'account'

  has_many :phone_numbers, foreign_key: 'account_id', class_name: 'PhoneNumber'
end