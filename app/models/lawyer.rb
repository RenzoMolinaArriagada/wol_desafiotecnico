class Lawyer < ApplicationRecord
	validates :email, presence: true, format: {with: URI::MailTo::EMAIL_REGEXP}
	validates :name, presence: true
	validates :surname, presence: true
end