class ApplicationController < ActionController::Base
  protect_from_forgery
  
  def create_directories(base_path,user_path)
    FileUtils.mkdir(base_path) unless File.directory?(base_path)
    FileUtils.mkdir(user_path) unless File.directory?(user_path)
  end
end
