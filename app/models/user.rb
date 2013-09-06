class User < ActiveRecord::Base
  before_save {self.email = email.downcase}
  before_create :create_remember_token
  
  validates :name, presence: true, length: { maximum: 50}
  VALID_EMAIL_REGEX = /\A[\w+\-.]+@[a-z\d\-.]+\.[a-z]+\z/i
  validates :email, presence: true, 
                    format: { with: VALID_EMAIL_REGEX}, 
                    uniqueness: {case_sensitive: false}
  validates :password, length: {minimum: 6} 
  has_secure_password
  
  def User.new_remember_token
    SecureRandom.urlsafe_base64
  end
  
  def User.encrypt(token)
    Digest::SHA1.hexdigest(token.to_s)
  end
  
  def send_password_reset
    generate_token(:password_reset_token)
    self.password_reset_sent_at = Time.zone.now
    save!(validate: false)
    UserMailer.password_reset(self).deliver
  end
  
  def generate_token(column)
    begin
        self[column] = SecureRandom.urlsafe_base64
      end while User.exists?(column => self[column])
  end
  
  private 
    def  create_remember_token
      begin
        self.remember_token = User.encrypt(User.new_remember_token)
      end while self.class.exists?(remember_token: remember_token) 
      # while... to ensure remember_token doesn't exist refer to Railscast episode# 352
    end
end
