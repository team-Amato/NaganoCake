class ApplicationController < ActionController::Base
<<<<<<< HEAD
    
before_action :configure_permitted_parameters, if: :devise_controller?

  def after_sign_in_path_for(resource)
    root_path
=======
  before_action :configure_permitted_parameters, if: :devise_controller?
  def after_sign_in_path_for(resource)
    items_path
>>>>>>> origin/develop
  end

  protected

  def configure_permitted_parameters
<<<<<<< HEAD
    devise_parameter_sanitizer.permit(:sign_up, keys: [:name])
  end
  
=======
    devise_parameter_sanitizer.permit(:sign_up, keys: [:email, :last_name, :first_name, :last_name_kana, :first_name_kana, :address, :phone_number, :post_code])
  end
>>>>>>> origin/develop
end
