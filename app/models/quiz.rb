# == Schema Information
#
# Table name: quizzes
#
#  id         :bigint           not null, primary key
#  topic      :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#
class Quiz < ApplicationRecord
  validates :topic, presence: true
  
  has_many  :messages, dependent: :destroy
end
