module V1
  class PostsController < BaseController
    def index
      posts = Post.all
      data = posts.map { |p| PostSerializer.new(p) }

      render json: api_response(data: data)
    end

    def show
      data = PostSerializer.new(post)

      render json: api_response(data: data)
    end

    def create
      post = Post.create!(post_params)
      data = PostSerializer.new(post)

      render json: api_response(data: data),
             location: v1_posts_path(post),
             status: :created
    end

    def update
      post.update!(post_params)
      data = PostSerializer.new(post)

      render json: api_response(data: data)
    end

    def destroy
      post.destroy!
    end

    private

    def post
      @post ||= Post.find(params[:id])
    end

    def post_params
      params.permit(:title, :text, :user_id)
    end
  end
end
