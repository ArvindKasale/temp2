class Element < ActiveRecord::Base
  belongs_to :category
  belongs_to :form
end
