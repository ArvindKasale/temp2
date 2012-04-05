class Form < ActiveRecord::Base
  belongs_to :user
  has_many :elements
  has_attached_file :image, :styles=>{:small=>"400X160"}
  validates :title, :presence=> true
  validates_attachment_presence :image
end
