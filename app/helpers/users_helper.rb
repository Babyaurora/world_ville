module UsersHelper
  # Returns the Gravatar (http://gravatar.com/) for the given user.
  def gravatar_for(user, options = { size: 80 })
    # gravatar_id = Digest::MD5::hexdigest(user.email.downcase)
    # size = options[:size]
    # gravatar_url = "https://secure.gravatar.com/avatar/#{gravatar_id}?s=#{size}"
    # image_tag(gravatar_url, alt: user.display_name, class: "gravatar")
    size = options[:size]
    if user.user_type == 0
      image_tag("girl.jpg", width: size, height: size, class: "gravatar")
    else
      image_tag("houses/house#{user.house_id}.jpg", size: "100x80", class: "gravatar")
    end
  end
end
