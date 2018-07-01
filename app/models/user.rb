class User < ApplicationRecord
    # Include default devise modules. Others available are:
    # :confirmable, :lockable, :timeoutable and :omniauthable
    has_secure_password 
    has_and_belongs_to_many :companies, class_name: "Company"
    has_many :posts

    attr_accessor :remember_token
    before_save {self.email = email.downcase}

    validates_presence_of :email, :username
    validates_uniqueness_of :email, :username
    validates_email_format_of :email, message: 'The email format is not correct!'
    validates :password, length: {minimum: 6, maximum: 30}, allow_nil: true
    validates :username, length: {maximum: 30}
    
    class << self
        def digest(string)
            cost = ActiveModel::SecurePassword.min_cost ? BCrypt::Engine::MIN_COST : BCrypt::Engine.cost
            BCrypt::Password.create(string, cost: cost)
        end

        def new_token
            SecureRandom.urlsafe_base64
        end
        def from_omniauth(auth)
            where(auth.slice("provider", "uid")).first || create_from_omniauth(auth)
        end
          
        def create_from_omniauth(auth)
            create! do |user|
              user.provider = auth["provider"]
              user.uid = auth["uid"]
              user.username = auth["info"]["last_name"]+" "+auth["info"]["first_name"]
              user.email =auth["info"]["email"]
              user.password_digest = '123456789'
            end
        end
    end

    def remember
        @remember_token = User.new_token
        update_attribute(:remember_digest, User.digest(remember_token))
    end

    def authenticated?(attribute, token)
        digest = send("#{attribute}_digest")
        return false if digest.nil?
        BCrypt::Password.new(digest).is_password?(token)
    end

    def forget
        update_attribute(:remember_digest, nil)
    end
  
  end
  