class HomeController < ApplicationController
  def top
    @newest_posts = Post.limit(6).order(updated_at: :desc)
    @most_favorite_posts = Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(6).pluck(:post_id))
  end
end
