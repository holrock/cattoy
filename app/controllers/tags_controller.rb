class TagsController < ApplicationController
  def index
    @tags = ActsAsTaggableOn::Tag.order(:name)
  end
end
