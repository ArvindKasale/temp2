class Category < ActiveRecord::Base
  
  has_many :elements, :dependent=> :destroy
end
