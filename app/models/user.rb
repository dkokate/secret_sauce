class User < ActiveRecord::Base
  has_many :recipes, dependent: :destroy
  has_many :relationships, foreign_key: "follower_id", dependent: :destroy
  has_many :followed_users, through: :relationships, source: :followed
  has_many :reverse_relationships, foreign_key: "followed_id", class_name: "Relationship", dependent: :destroy
  has_many :followers, through: :reverse_relationships, source: :follower 
  # 'source: :follower' is not reqd becasue Rails will automatically pluralize follower to followers unlike followed_users
  
  has_many :platters, dependent: :destroy
  has_many :interests, dependent: :destroy
  
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
  
  def feed
    Recipe.from_users_followed_by(self)
    # Recipe.where("user_id = ?", id)
  end
  
  def following?(other_user)
    self.relationships.find_by(followed_id: other_user.id)
  end
  
  def follow!(other_user)
    self.relationships.create!(followed_id: other_user.id)
  end
  
  def unfollow!(other_user)
    self.relationships.find_by(followed_id: other_user.id).destroy!
  end
  
  # --------------------------------------------------------------
  def platter_feed
    Platter.from_platters_followed_by(self)
  end
  
  def following_platter?(platter)
    self.interests.find_by(platter_id: platter.id)
  end
  
  def follow_platter!(platter)
    self.interests.create!(platter_id: platter.id)
    pl = Platter.find(platter.id)
    pl.update(last_platter_activity_at: DateTime.now.utc)
  end
  
  def unfollow_platter!(platter)
    self.interests.find_by(platter_id: platter.id).destroy!
  end
  # --------------------------------------------------------------

  private 
    def  create_remember_token
      begin
        self.remember_token = User.encrypt(User.new_remember_token)
      end while self.class.exists?(remember_token: remember_token) 
      # while... to ensure remember_token doesn't exist refer to Railscast episode# 352
    end
end
