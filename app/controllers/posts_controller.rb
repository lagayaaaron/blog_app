class PostsController < ApplicationController
  before_action :authenticate_user!, except: [ :index, :show ] # Ensure user is authenticated for actions except index and show
  before_action :set_post, only: %i[show edit update destroy]

  # GET /posts or /posts.json
  def index
    @posts = Post.all
  end

  # GET /posts/1 or /posts/1.json
  def show
  end

  # GET /posts/new
  def new
    @post = current_user.posts.new # Ensure the post belongs to the current user
  end

  # GET /posts/1/edit
  def edit
    # Check if the current user is the owner of the post before allowing them to edit
    unless @post.user == current_user
      redirect_to posts_path, alert: "You are not authorized to edit this post."
    end
  end

  # POST /posts or /posts.json
  def create
    @post = current_user.posts.new(post_params) # Ensure the post belongs to the current user

    respond_to do |format|
      if @post.save
        format.html { redirect_to @post, notice: "Post was successfully created." }
        format.json { render :show, status: :created, location: @post }
      else
        format.html { render :new, status: :unprocessable_entity }
        format.json { render json: @post.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /posts/1 or /posts/1.json
  def update
    # Check if the current user is the owner of the post before allowing them to update
    unless @post.user == current_user
      redirect_to posts_path, alert: "You are not authorized to update this post."
    else
      respond_to do |format|
        if @post.update(post_params)
          format.html { redirect_to @post, notice: "Post was successfully updated." }
          format.json { render :show, status: :ok, location: @post }
        else
          format.html { render :edit, status: :unprocessable_entity }
          format.json { render json: @post.errors, status: :unprocessable_entity }
        end
      end
    end
  end

  # DELETE /posts/1 or /posts/1.json
  def destroy
    # Check if the current user is the owner of the post before allowing them to destroy it
    unless @post.user == current_user
      redirect_to posts_path, alert: "You are not authorized to delete this post."
    else
      @post.destroy

      respond_to do |format|
        format.html { redirect_to posts_path, status: :see_other, notice: "Post was successfully destroyed." }
        format.json { head :no_content }
      end
    end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_post
      @post = Post.find(params[:id])
    end

    # Only allow a list of trusted parameters through.
    def post_params
      params.require(:post).permit(:title, :content, :user_id)
    end
end
