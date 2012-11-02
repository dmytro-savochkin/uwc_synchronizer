class Sync::GistController < ApplicationController
  def show
    @user = current_user

    github = storage_class_by_name('github')
    cloud = @user.preferred_cloud
    if github and cloud
      @gists = {}
      fill_gists_instance(github.get_gists, :github)
      fill_gists_instance(cloud.get_gists, :cloud)
      @gists
    else
      redirect_to root_path
    end
  rescue Dropbox::API::Error
    dropbox_api_error_flash_message
    redirect_to sync_show_gists_path
  end


  def upload
    gists_to_update = []
    gist_ids_to_delete = []

    incoming_gists_data = params[:gists]
    incoming_gists_data.each do |gist|
      gist_index = gist.first
      gist_data = gist.last
      action = gist_data[:action]
      if action == 'delete'
        gist_ids_to_delete << gist_index
      elsif action != 'nothing'
        gist_data[action][:recreate] = true if action == 'cloud'
        gist_to_update = gist_data[action]
        gists_to_update << gist_to_update
      end
    end

    github = storage_class_by_name('github')
    cloud = current_user.preferred_cloud

    github.delete_gists gist_ids_to_delete
    cloud_gists_map_to_change = github.put_gists gists_to_update

    old_ids = cloud_gists_map_to_change.keys
    renewed_gists_to_update = change_cloud_gists_ids gists_to_update, cloud_gists_map_to_change

    cloud.delete_gists(old_ids + gist_ids_to_delete)
    cloud.put_gists renewed_gists_to_update

    flash[:success] = "Files were successfully stored in the cloud"
  rescue Dropbox::API::Error
    dropbox_api_error_flash_message
  #rescue Exception => e
  #  flash[:error] = "Some error occurred: " + e.to_s
  ensure
      redirect_to sync_show_gists_path
  end








  private

  def dropbox_api_error_flash_message
    flash[:error] = "Dropbox API error occurred. Please try again later (really this happens sometimes)."
  end

  def change_cloud_gists_ids(gists, how_to_change)
    how_to_change.each do |old_id, new_id|
      gists.select{|g| g[:id] == old_id}.first[:id] = new_id
    end
    gists
  end

  def fill_gists_instance(gists, storage)
    gists.each do |key, gist|
      @gists[gist[:id]] ||= {}
      @gists[gist[:id]][storage] = gist
    end
  end

  def storage_class_by_name(name)
    if name == 'github'
      current_user.social_networks.select{|n| n.class == Social::Networks::Github}.first
    else
      current_user.clouds.select{|n| n.class == ('Social::Clouds::' + name.capitalize).constantize}.first
    end
  end
end
