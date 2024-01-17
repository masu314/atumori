class HomeController < ApplicationController
  def top
    posts = Post.with_attached_image.includes([:user])
    @newest_posts = posts.limit(6).order(created_at: :desc)
    @most_favorite_posts = posts.limit(6).order(favorites_count: :desc)
    @most_popular_tags = Tag.find(PostTagRelation.group(:tag_id).order('count(tag_id) desc').limit(7).pluck(:tag_id))
    @q = Post.includes([:favorites]).ransack(params[:q])
    @categories = Category.roots
  end

  def terms
  end

  def policy
  end
end
