class Avatar < ActiveRecord::Base
  belongs_to :user

  def self.delete_temp_avatars(links_in_json)
    links = JSON.parse links_in_json
    links.each do |link_array|
      link = link_array.last
      File.delete link if File.exist? link
    end
  end


  def save_response_as_file(storage_name, data)
    avatar_path = './public/assets/images/avatars/'+ self.user.id.to_s + storage_name.to_s  + Digest::MD5.hexdigest(data) + '.jpg'

    File.open(avatar_path, 'wb') do |f|
      f.write(data)
    end

    self[storage_name] = data
    avatar_path
  end
end