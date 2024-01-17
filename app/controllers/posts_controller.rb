class PostsController < ApplicationController
  before_action :set_parents, only: ["new", "edit", "index", "create", "update"]
  before_action :set_form_childs, only: ["edit", "update"]
  before_action :set_search_childs, only: ["index"]

  def index
    if params[:q].present?
      @q = Post.ransack(params[:q])
      @posts = @q.result(distinct: true)
      if @q_header
        @posts = @q_header.result(distinct: true)
      end
    else
      params[:q] = { sorts: 'created_at desc' }
      @q = Post.ransack(params[:q])
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

  def create
    @post = Post.new(post_params)
    @post.user_id = current_user.id
    tag_names = params[:post][:tag_names].split(',')

    if @post.save
      if tag_names.present?
        tags = tag_names.split(",").map(&:strip).uniq
        create_or_update_post_tags(@post, tags)
      end
      flash[:notice] = "投稿しました"
      redirect_to :posts
    else
      render "new"
    end
  end

  def edit
    @post = Post.find(params[:id])
  end

  def update
    @post = Post.find(params[:id])
    tag_names = params[:post][:tag_names]

    if @post.update(post_params)
      if tag_names.present?
        tags = params[:post][:tag_names].split(",").map(&:strip).uniq
        create_or_update_post_tags(@post, tags)
      elsif @post.tags.present?
        destroy_post_tags(@post)
      end
      flash[:notice] = "更新しました"
      redirect_to :post
    else
      render "edit"
    end
  end

  def destroy
    @post = Post.find(params[:id])
    @post.destroy
    flash[:notice] = "投稿を削除しました"
    redirect_to :posts
  end

  def get_category_children
    @category_children = Category.find(params[:parent_id].to_s).children
  end

  private

  def set_parents
    @set_parents = Category.where(ancestry: nil)
  end

  def set_form_childs
    post = Post.find(params[:id])
    if !post.category.root?
      @set_childs = Category.where(ancestry: post.category.parent.id)
    end
  end

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

  def create_or_update_post_tags(post, tags)
    post.tags.destroy_all
    begin
    tags.each do |tag|
      tag = Tag.find_or_create_by(name: tag)
      binding.pry
      post.tags << tag
      binding.pry
      rescue ActiveRecord::RecordInvalid
        false
      end
    end
  end

  def destroy_post_tags(post)
    old_tags = post.tags

    old_relations = PostTagRelation.where(post_id: post.id)
    old_relations.each do |relation|
      relation.delete
        binding.pry
    end

    old_tags.each do |tag|
      if PostTagRelation.where(tag_id: tag.id).blank?
        Tag.find(tag.id).delete
      end
    end
  end
end
