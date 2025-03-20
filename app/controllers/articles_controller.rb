class ArticlesController < ApplicationController
  def index
    @articles = Article.all
  end

  def show
    @article = Article.find(params[:id])
  end

  def new
    @article = Article.new
  end

  def create
    @article = Article.new(article_params)

    # これは大丈夫
    # @article.images.attach(params[:article][:images])

    # これはダメ、以下のエラーが発生する
    # SQLite3::ConstraintException: # UNIQUE constraint failed:
    # active_storage_attachments.record_type,
    # active_storage_attachments.record_id,
    # active_storage_attachments.name,
    # active_storage_attachments.blob_id
    params[:article][:images].each do |image|
      @article.images.attach(image)
    end

    # ただしエラーになるのはダイレクトアップロードの場合のみ

    if @article.save
      redirect_to @article, notice: "Article was successfully created."
    else
      render :new, status: :unprocessable_entity
    end
  end

  def edit
    @article = Article.find(params[:id])
  end

  def update
    @article = Article.find(params[:id])
    if @article.update(article_params)
      redirect_to @article, notice: "Article was successfully updated."
    else
      render :edit, status: :unprocessable_entity
    end
  end

  private

  def article_params
    params.require(:article).permit(:title)
  end
end
