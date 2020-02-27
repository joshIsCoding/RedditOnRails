module PostsHelper
  def current_user_is_mod?(post)
    post.sub_mods.include?(current_user)
  end
end
