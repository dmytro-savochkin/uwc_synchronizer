class Sync::ProfileController < ApplicationController
  def edit
    @user = current_user
  end


  def update
    profile_params = params[:profile]
    @user = current_user
    networks_to_update = @user.all_updatable_networks_without(factory(profile_params[:provider]))
    all_updated = networks_to_update.each {|n| n.put_info profile_params}
    if all_updated.any?
      flash[:success] =
          'You have updated your profile on ' +
          networks_to_update.map(&:class_name_without_module).join(', ')
    elsif networks_to_update.empty?
      flash[:error] = 'Nothing to update'
    else
      flash[:error] = 'Some error occured'
    end
    redirect_to sync_edit_profile_path
  end
end
