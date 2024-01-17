class HomeController < ApplicationController
  def top
    @newest_posts = Post.limit(6).order(updated_at: :desc)
    @most_favorite_posts = Post.find(Favorite.group(:post_id).order('count(post_id) desc').limit(6).pluck(:post_id))
    @most_popular_tags = Tag.find(PostTagRelation.group(:tag_id).order('count(tag_id) desc').limit(7).pluck(:tag_id))
    @q = Post.ransack(params[:q])
    @categories = Category.roots
  end

  def terms
  end

  def policy
  end
end
