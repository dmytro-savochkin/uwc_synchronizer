class Sync::CvController < ApplicationController
  def show
    @user = current_user

    linkedin = @user.social_networks.select{|n| n.class == Social::Linkedin}.first
    cloud = @user.preferred_cloud
    if linkedin and cloud
      @cv = {:linkedin => linkedin.get_cv_data, :cloud => cloud.get_cv_data}
    else
      redirect_to root_path
    end
  end

  def upload
    @user = current_user

    cv_data = params[:cv_data]
    cv_file_name = params[:cv_file_name].to_s.split('.').first.sub(/[^\w]/, '').downcase + '.txt'
    if cv_file_name
      @user.preferred_cloud.cv_file_name = cv_file_name
      @user.preferred_cloud.save
      @user.preferred_cloud.post_cv cv_data
      flash[:success] = "File successfully stored in the cloud as #{@user.preferred_cloud.cv_folder}/#{cv_file_name}"
      redirect_to root_path
    else
      @cv = {:linkedin => cv_data, :cloud => @user.preferred_cloud.get_cv_data}
      flash.now[:error] = "Wrong path"
      render :show
    end
  end
end
