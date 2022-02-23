class NotFoundController < ApplicationController
  def index
    render json: {error: "Not found"}, status: 404
  end
end
