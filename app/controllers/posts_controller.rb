class PostsController < ApplicationController
  before_action :authenticate_user!, only: ["new", "edit", "create", "update", "destroy"]
  before_action :authenticate_post, only: ["edit", "update", "destroy"]
  before_action :set_parents, only: ["new", "edit", "index", "create", "update"]
  before_action :set_form_childs, only: ["edit", "update"]
  before_action :set_search_childs, only: ["index"]

  def index
    if params[:q].present?
      @q = Post.with_attached_image.preload(:user).ransack(params[:q])
      @posts = @q.result(distinct: true)
      if @q_header
        @posts = @q_header.result(distinct: true)
      end
    else
      params[:q] = { sorts: 'created_at desc' }
      @q = Post.with_attached_image.preload(:user).ransack(params[:q])
      @posts = @q.result(distinct: true)
    end
  end

  def show
    @q = Post.ransack(params[:q])
    @post = Post.find(params[:id])
  end

  def new
    @post = Post.new
  end

  def edit
    @post = Post.find(params[:id])
    @tag_names = @post.tags.pluck(:name).join(',')
  end

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_names = params[:post][:tag_names].split(',')

    if @post.save
      @post.save_tags(tag_names)
      redirect_to :posts, notice: "投稿しました"
    else
      render "new"
    end
  end

  def update
    @post = Post.find(params[:id])
    #入力されたタグを配列に入れる
    tag_names = params[:post][:tag_names].split(',')

    if @post.update(post_params)
      @post.save_tags(tag_names)
      redirect_to :post, notice: "更新しました"
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to :posts, notice: "投稿を削除しました"
  end

  #JSON用のアクション
  def get_category_children
    #ajax通信で送られてきた親カテゴリーから、紐づく小カテゴリーを取得
    @category_children = Category.find(params[:parent_id].to_s).children
  end

  private

  #親カテゴリーのみを抽出した変数を定義（検索画面でも、フォーム画面でも利用）
  def set_parents
    @set_parents = Category.where(ancestry: nil)
  end

  #子カテゴリーのみを抽出した変数を定義（フォーム画面で利用）
  def set_form_childs
    post = Post.find(params[:id])
    if !post.category.root?
      @set_childs = Category.where(ancestry: post.category.parent.id)
    end
  end

  #子カテゴリーのみを抽出した変数を定義（検索画面で利用）
  def set_search_childs
    if (params[:q].present?) && (params[:q][:category_ancestry_or_category_id_eq].present?)
      @exist_category = Category.find(params[:q][:category_ancestry_or_category_id_eq])
      @set_childs = Category.where(ancestry: @exist_category.id)
      if params[:q][:category_id_eq].present?
        @exist_child_category = Category.find(params[:q][:category_id_eq])
      end
    end
  end

  def post_params
    params.require(:post).permit(:title, :image, :text, :work_id, :author_id, :user_id, :category_id)
  end

  def authenticate_post
    @post = Post.find(params[:id])
    if @post.user_id != current_user.id
      redirect_to :post, alert: "他のユーザーの投稿は編集・削除できません。"
    end
  end
end
