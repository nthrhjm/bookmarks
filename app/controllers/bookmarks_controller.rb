class BookmarksController < ApplicationController
  before_action :authenticate_user!
  before_action :set_bookmark, only: [:show, :edit, :update, :destroy]
  before_action :bookmark_search, only: [:index, :show, :new, :edit]
  # GET /bookmarks
  # GET /bookmarks.json
  def index

    @bookmarks = @q.result(distinct: true).page(params[:page]).order('created_at desc').per(10)

  end

  # GET /bookmarks/1
  # GET /bookmarks/1.json
  def show
    if @bookmark.user_id != current_user.id
      redirect_to root_path
    end
  end

  # GET /bookmarks/new
  def new
    @bookmark = Bookmark.new
  end

  # GET /bookmarks/1/edit
  def edit
    if @bookmark.user_id != current_user.id
      redirect_to root_path
    end
  end

  # POST /bookmarks
  # POST /bookmarks.json
  def create
    @bookmark = Bookmark.new(bookmark_params)

    respond_to do |format|
      if @bookmark.save
        format.html { redirect_to root_path, notice: 'Bookmark was successfully created.' }
        format.json { render :show, status: :created, location: @bookmark }
      else
        format.html { render :new }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /bookmarks/1
  # PATCH/PUT /bookmarks/1.json
  def update
    respond_to do |format|
      if @bookmark.update(bookmark_params)
        format.html { redirect_to root_path, notice: 'Bookmark was successfully updated.' }
        format.json { render :show, status: :ok, location: @bookmark }
      else
        format.html { render :edit }
        format.json { render json: @bookmark.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /bookmarks/1
  # DELETE /bookmarks/1.json
  def destroy
    if @bookmark.user_id != current_user.id
      redirect bookmark_path
    else
      @bookmark.destroy
      respond_to do |format|
        format.html { redirect_to bookmarks_url, notice: 'Bookmark was successfully destroyed.' }
        format.json { head :no_content }
      end
    end
  end

  private

  # Use callbacks to share common setup or constraints between actions.
  def set_bookmark
    @bookmark = Bookmark.find(params[:id])
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def bookmark_params
    params.require(:bookmark).permit(:url, :title, :description).merge(user_id: current_user.id)
  end

  def bookmark_search

    @q = current_user.bookmarks.ransack(params[:q])
    @url = request.url

  end
end
