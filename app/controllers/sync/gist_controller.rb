class Sync::GistController < ApplicationController
  def show
    @user = current_user

    github = storage_class_by_name('github')
    cloud = @user.preferred_cloud
    if github and cloud
      @gists = {:github => github.get_gists_data, :cloud => cloud.get_gists_data}
    else
      redirect_to root_path
    end
  end


  def upload
    begin
      gists_to_update = {}
      in_gists = params[:gists]
      in_gists.each do |gist|
        gist_data = gist.last
        storage_name = gist_data[:sync]
        if storage_name != 'disabled'
          gist_to_update = gist_data[storage_name]
          gists_to_update[storage_name] ||= []
          gists_to_update[storage_name] << gist_to_update
        end
      end

      gists_to_update.each do |storage, gists|
        storage_class = storage_class_by_name storage
        storage_class.put_gists_data gists
      end


      flash[:success] = "Files were successfully stored in the cloud"
    rescue Exception => e
      flash[:error] = "Some error occured " + e.to_s
    end
    redirect_to sync_show_gists_path
  end



  private

  def storage_class_by_name(name)
    logger.info name
    if name == 'github'
      current_user.social_networks.select{|n| n.class == Social::Github}.first
    else
      current_user.clouds.select{|n| n.class == ('Social::' + name.capitalize).constantize}.first
    end
  end
end
