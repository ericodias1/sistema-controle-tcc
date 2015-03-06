class Teacher < ActiveRecord::Base
  has_many :timeline
  validates :name, :presence => {message: 'O nome do professor é um valor obrigatório' }
  validates :access, :presence => {message: 'O tipo de acesso do professor é um valor obrigatório' }
end
