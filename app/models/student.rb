class Student < ActiveRecord::Base
  has_many :timeline
  has_one :password, :dependent => :destroy
  validates_presence_of :ra
  validates_uniqueness_of :ra
  validates_presence_of :name
  validates_presence_of :email
  validates_uniqueness_of :email
  validates_presence_of :login
  validates_uniqueness_of :login
  validates :email, format: { with: /\A([^@\s]+)@((?:[-a-z0-9]+\.)+[a-z]{2,})\z/i }

  after_create :create_default_password

  def self.search(search)
    if search
        where(['lower(name) LIKE ?', "%#{search}%".downcase])
    else
        all
    end
  end

  def create_default_password
    Password.create student: self, password: 'abc123'
  end
end
