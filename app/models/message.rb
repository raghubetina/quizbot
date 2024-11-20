# == Schema Information
#
# Table name: messages
#
#  id         :bigint           not null, primary key
#  content    :text
#  role       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#  quiz_id    :integer
#
class Message < ApplicationRecord
  validates :role, inclusion: { in: [ "system", "assistant", "user" ] }
  validates :role, presence: true
  validates :quiz_id, presence: true
  validates :content, presence: true
  
  belongs_to :quiz
end
