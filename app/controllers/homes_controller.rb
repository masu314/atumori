class HomesController < ApplicationController
  # トップページ用の情報を取得
  def top
    posts = Post.with_attached_image.includes([:user])
     # 最新の投稿6件を取得
    @newest_posts = posts.limit(6).order(created_at: :desc)
    # お気に入り数が多い投稿6件を取得
    @most_favorite_posts = posts.limit(6).order(favorites_count: :desc)
    # 人気のタグを取得
    @most_popular_tags = Tag.find(PostTagRelation.group(:tag_id).order('count(tag_id) desc').limit(7).pluck(:tag_id))
     # 投稿検索フォームの検索結果を取得
    @q = Post.includes([:favorites]).ransack(params[:q])
    # カテゴリの親カテゴリーを取得
    @categories = Category.roots
  end

   # 利用規約ページ
  def terms
  end

  # プライバシーポリシーページ
  def policy
  end
end
