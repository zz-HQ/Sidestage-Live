class Authentication::RegistrationsController < Devise::RegistrationsController

  #
  # Settings
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  
  before_action :configure_permitted_parameters

  helper_method :after_sign_up_path_for
  
  respond_to :html, :js
  
  #
  # Actions
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  

  def create
    build_resource(sign_up_params)

    if resource.save
      respond_to do |format|
        format.html {
          yield resource if block_given?
          if resource.active_for_authentication?
            set_flash_message :notice, :signed_up if is_flashing_format?
            sign_up(resource_name, resource)
            respond_with resource, :location => after_sign_up_path_for(resource)
          else
            set_flash_message :notice, :"signed_up_but_#{resource.inactive_message}" if is_flashing_format?
            expire_data_after_sign_in!
            respond_with resource, :location => after_inactive_sign_up_path_for(resource)
          end
        }
        format.js {
          flash[:notice] = "Created account, signed in."
          render :template => "devise/registrations/create"
          flash.discard
          # sign_up(resource_name, resource)
        }
      end
    else
      respond_to do |format|
        format.html {
          clean_up_passwords resource
          respond_with resource
        }
        format.js {
          flash[:alert] = @user.errors.full_messages.to_sentence
          render template: "devise/registrations/new"
          flash.discard
        }
      end
    end
  end


  #
  # Protected
  # ---------------------------------------------------------------------------------------
  #
  #
  #
  #
  
  protected 

  def after_sign_up_path_for(resource)
    assign_potential_profile
    root_path
  end
  
  def after_inactive_sign_up_path_for(resource)
    assign_potential_profile
    root_path
  end
  
  def assign_potential_profile
    if session[:profile].present?
      profile = Profile.new(session[:profile]) 
      resource.profiles << profile
      session[:profile] = nil
    end
  end
  
  def configure_permitted_parameters
    devise_parameter_sanitizer.for(:sign_up) << [:first_name, :last_name, :newsletter_subscribed]
  end    
    
end
