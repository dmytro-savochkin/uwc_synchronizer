class Sync::GistController < ApplicationController
  def show
    @user = current_user

    github = storage_class_by_name('github')
    cloud = @user.preferred_cloud
    if github and cloud
      @gists = {}
      fill_gists_instance(github.get_gists_data, :github)
      fill_gists_instance(cloud.get_gists_data, :cloud)
      @gists
    else
      redirect_to root_path
    end
  end


  def upload
    gists_to_update = []

    incoming_gists_data = params[:gists]
    incoming_gists_data.each do |gist|
      gist_data = gist.last
      storage_from = gist_data[:from]
      if storage_from != 'disabled'
        gist_data[storage_from][:recreate] = true if storage_from == 'cloud'
        gist_to_update = gist_data[storage_from]
        gists_to_update << gist_to_update
      end
    end

    cloud_gists_ids_to_change = storage_class_by_name('github').put_gists_data gists_to_update
    old_ids = cloud_gists_ids_to_change.keys

    logger.info cloud_gists_ids_to_change.to_yaml

    renewed_gists_to_update = change_cloud_gists_ids gists_to_update, cloud_gists_ids_to_change
    current_user.preferred_cloud.delete_gists old_ids
    current_user.preferred_cloud.put_gists_data renewed_gists_to_update


    flash[:success] = "Files were successfully stored in the cloud"
    redirect_to sync_show_gists_path
  #rescue Exception => e
  #  flash[:error] = "Some error occurred " + e.to_s
  #  redirect_to sync_show_gists_path
  end








  private

  def change_cloud_gists_ids(gists, how_to_change)
    logger.info gists.to_yaml
    how_to_change.each do |old_id, new_id|
      gists.select{|g| g[:id] == old_id}.first[:id] = new_id
    end
    logger.info gists.to_yaml
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
      current_user.social_networks.select{|n| n.class == Social::Github}.first
    else
      current_user.clouds.select{|n| n.class == ('Social::' + name.capitalize).constantize}.first
    end
  end
end
