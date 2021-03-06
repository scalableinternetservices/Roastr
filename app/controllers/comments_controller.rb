class CommentsController < ApplicationController
  before_action :set_comment, only: [:show, :edit, :update, :destroy]
  # before_action :set_user
  before_action :set_post

  # GET /comments
  # GET /comments.json
  def index
    # if the current user exists, then
    puts "Session user"
    puts session[:user_id].class
    if current_user
      @comments = Comment.where(user_id: session[:user_id])
    end
  end

  # GET /comments/1
  # GET /comments/1.json
  def show
  end

  # GET /comments/new
  def new
    @comment = Comment.new
  end

  # GET /comments/1/edit
  def edit
  end

  # POST /comments
  # POST /comments.json
  #   respond_to do |format|
  #     if @comment.save
  #       format.html { redirect_to post_path(@post_id), notice: 'Comment was successfully created.' }
  #       format.json { render :show, status: :created, location: @comment }
  #     else
  #       format.html { render :new }
  #       format.json { render json: @comment.errors, status: :unprocessable_entity }
  #     end
  #   end
  # end

  def create
    @comment = Comment.new(comment_params)
    if @comment.save
      redirect_to post_path(@comment.post_id)
    end
  end


  # PATCH/PUT /comments/1
  # PATCH/PUT /comments/1.json
  def update
    if current_user == nil or current_user.id != @comment.user_id
      respond_to do |format|
          format.html { redirect_to posts_url, notice: 'You do not have the proper permissions to edit that comment.' }
          format.json { render json: {'error' => 'You do not have the proper permissions to edit that comment.'} }
      end
      return
    end
    respond_to do |format|
      if @comment.update(comment_params)
        format.html { redirect_to post_path(@comment.post_id), notice: 'Comment was successfully updated.' }
        format.json { render :show, status: :ok, location: @comment }
      else
        format.html { render :edit }
        format.json { render json: @comment.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /comments/1
  # DELETE /comments/1.json
  def destroy
    if current_user == nil or current_user.id != @comment.user_id
      respond_to do |format|
          format.html { redirect_to posts_url, notice: 'You do not have the proper permissions to delete that comment.' }
          format.json { render json: {'error' => 'You do not have the proper permissions to delete that comment.'} }
      end
      return
    end
    @comment.destroy
    redirect_to post_path(@comment.post_id)


    # respond_to do |format|
    #   format.html { redirect_to comments_url, notice: 'Comment was successfully destroyed.' }
    #   format.json { head :no_content }
    # end
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_comment
      @comment = Comment.find(params[:id])
    end

    def set_post
      @post_id = params[:post_id]
    end

    def set_user
      @user = User.find(params[:user_id])
    end

    # Never trust parameters from the scary internet, only allow the white list through.
    def comment_params
      p = params.require(:comment).permit(:post_id, :comment)
      if current_user
        p[:user_id] = current_user.id
      end
      return p
    end
end
