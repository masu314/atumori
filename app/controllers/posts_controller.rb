class PostsController < ApplicationController
  # 投稿の作成・編集・更新・削除時にログインユーザーか確認
  before_action :authenticate_user!, only: ["new", "edit", "create", "update", "destroy"]
  # 投稿がユーザー自身のものであるか確認
  before_action :authenticate_post, only: ["edit", "update", "destroy"]
  # 親カテゴリー情報を取得（フォームや検索時に使用）
  before_action :set_parents, only: ["new", "edit", "index", "create", "update"]
  # 投稿編集・更新時に子カテゴリー情報を設定
  before_action :set_form_childs, only: ["edit", "update"]
  # 投稿検索画面で子カテゴリー情報を設定
  before_action :set_search_childs, only: ["index"]

   # 投稿一覧を表示（検索機能も含む）
  def index
    if params[:q].present?
      # 検索条件があれば、それに基づいて投稿を取得
      @q = Post.with_attached_image.preload(:user).ransack(params[:q])
      @posts = @q.result(distinct: true)
      # ヘッダー検索用の結果があれば、それを優先
      if @q_header
        @posts = @q_header.result(distinct: true)
      end
    else
      # 検索条件が無ければ、作成日時順に投稿を取得
      params[:q] = { sorts: 'created_at desc' }
      @q = Post.with_attached_image.preload(:user).ransack(params[:q])
      @posts = @q.result(distinct: true)
    end
  end

  # 投稿詳細を取得
  def show
    @q = Post.ransack(params[:q])
    @post = Post.find(params[:id])
  end

  # 新規投稿フォームを表示させるための処理
  def new
    @post = Post.new
  end

  # 投稿の編集フォームを表示させるための処理
  def edit
    @post = Post.find(params[:id])
    @tag_names = @post.tags.pluck(:name).join(',')
  end

  # 新しい投稿を作成
  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_names = params[:post][:tag_names].split(',')

    # 保存が成功した場合は、投稿にタグを関連付ける
    if @post.save
      @post.save_tags(tag_names)
      redirect_to :posts, notice: "投稿しました"
    # 失敗した場合は、新規作成画面を再表示
    else
      render "new"
    end
  end

   # 投稿を更新
  def update
    @post = Post.find(params[:id])
    # 入力されたタグを配列に入れる
    tag_names = params[:post][:tag_names].split(',')
    # 更新が成功した場合は、投稿にタグを紐づける
    if @post.update(post_params)
      @post.save_tags(tag_names)
      redirect_to :post, notice: "更新しました"
    # 失敗した場合は、編集画面を再表示
    else
      render "edit"
    end
  end

  # 投稿を削除
  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    redirect_to :posts, notice: "投稿を削除しました"
  end

  # 新規投稿フォームで、親カテゴリーに紐づく子カテゴリーを取得
  # JSON用のアクション
  def get_category_children
    # ajax通信で送られてきた親カテゴリーから、紐づく小カテゴリーを取得
    @category_children = Category.find(params[:parent_id].to_s).children
  end

  private

  # フォームや検索時に、親カテゴリーのみを取得
  def set_parents
    @set_parents = Category.where(ancestry: nil)
  end

  # 編集フォームで、親カテゴリーに紐づく子カテゴリーを取得
  def set_form_childs
    post = Post.find(params[:id])
    if !post.category.root?
      @set_childs = Category.where(ancestry: post.category.parent.id)
    end
  end

  # 検索時に、選択されたカテゴリーの子カテゴリーを取得
  def set_search_childs
    # 検索パラメータが存在しており、かつカテゴリーが選択されている場合
    if (params[:q].present?) && (params[:q][:category_ancestry_or_category_id_eq].present?)
      # 親カテゴリーを取得
      @exist_category = Category.find(params[:q][:category_ancestry_or_category_id_eq])
      # 親カテゴリーに紐づく子カテゴリーを取得
      @set_childs = Category.where(ancestry: @exist_category.id)
    end
  end

  # 投稿フォームのパラメータを許可
  def post_params
    params.require(:post).permit(:title, :image, :text, :work_id, :author_id, :user_id, :category_id)
  end

  # ユーザーが投稿の所有者であることを確認
  def authenticate_post
    @post = Post.find(params[:id])
    if @post.user_id != current_user.id
      redirect_to :post, alert: "他のユーザーの投稿は編集・削除できません。"
    end
  end
end
