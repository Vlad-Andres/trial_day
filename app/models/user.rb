class User < ApplicationRecord
    has_many :todos
    
    validates :name, presence: true

    has_secure_password
end
