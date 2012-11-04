class Sync::AvatarController < ApplicationController
  def edit
    @user = current_user
    @avatars = {:data => {}, :links => {}}
    session[:avatar_redirects] = nil

    get_storages.each do |storage_name, storage|
      avatar_data = storage.get_avatar

      if avatar_data
        @user.avatar ||= Avatar.new
        avatar_path = @user.avatar.save_response_as_file storage_name, avatar_data

        logger.info storage_name
        logger.info avatar_path

        @avatars[:links][storage_name] = avatar_path
        @avatars[storage_name] = avatar_path
        @user.avatar.save
      end
    end
  end



  def update
    storages = get_storages
    responses = {}
    storages_without_selected = storages.reject{|k,s| params[:from] == k.to_s}

    logger.info storages_without_selected

    storages_without_selected.each do |storage_name, storage|
      responses[storage_name] = storage.post_avatar(current_user.avatar[params[:from]])
      logger.info responses[storage_name]
    end

    Avatar.delete_temp_avatars params[:links]

    let_them_process

    make_redirect_if_need_to_approve(responses)
  #rescue Exception => e
  #  flash[:error] = 'Some error occurred: ' + e.message.to_s
  #  redirect_to sync_edit_avatar_path
  end



  def approve
    @user = current_user
    @redirects = session[:avatar_redirects] || {}
  end






  private

  def let_them_process
    sleep 3 # let Twitter and others update our avatars :)
  end

  def make_redirect_if_need_to_approve(responses)
    if responses.any?{|response| response.last[:redirect]}
      session[:avatar_redirects] = responses.select{|key, response| response[:redirect]}
      redirect_to sync_approve_avatar_path
    else
      flash[:success] = 'You have successfully synced your avatars'
      redirect_to sync_edit_avatar_path
    end
  end

  def get_storages
    @user ||= current_user
    storages = {}
    storages[:twitter] = @user.social_networks.select{|n| n.class == Social::Networks::Twitter}.first
    storages[:facebook] = @user.social_networks.select{|n| n.class == Social::Networks::Facebook}.first
    storages[:cloud] = @user.preferred_cloud
    storages
  end
end