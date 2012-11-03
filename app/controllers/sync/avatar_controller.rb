class Sync::AvatarController < ApplicationController


  def edit
    @user = current_user
    @avatars = {:data => {}, :links => {}}
    session[:avatar_redirects] = nil

    storages = get_storages
    binary_avatars = {}
    binary_avatars[:cloud] = storages[:cloud].get_avatar

    if binary_avatars[:cloud]
      cloud_avatar_was_changed = binary_avatars[:cloud] != storages[:cloud].picture_data

      storages[:cloud].picture_data = binary_avatars[:cloud]
      storages[:cloud].save

      if cloud_avatar_was_changed
        responses = {}
        responses[:twitter] = storages[:twitter].post_avatar binary_avatars[:cloud]
        responses[:facebook] = storages[:facebook].post_avatar binary_avatars[:cloud]
        make_redirect_if_need_to_approve(responses)
      end
    end


    binary_avatars[:twitter] = storages[:twitter].get_avatar
    binary_avatars[:facebook] = storages[:facebook].get_avatar

    binary_avatars.each do |storage, avatar_data|
      unless avatar_data.nil?
        avatar_path = './public/assets/images/avatars/'+ @user.id.to_s + storage.to_s  + Digest::MD5.hexdigest(avatar_data) + '.jpg'
        File.open(avatar_path, 'wb') do |f|
          f.write(avatar_data)
        end

        @user.avatar ||= Avatar.new
        @user.avatar[storage] = avatar_data

        @avatars[:links][storage] = avatar_path
        @avatars[storage] = avatar_path
      end
    end
    @user.avatar.save
  end



  def update
    storages = get_storages
    responses = {}
    storages.reject{|k,s|params[:from] == k.to_s}.each do |storage_name, storage|
      responses[storage_name] = storage.post_avatar(current_user.avatar[params[:from]])
    end

    links = JSON.parse(params[:links])
    links.each do |link_array|
      link = link_array.last
      File.delete link if File.exist? link
    end

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
