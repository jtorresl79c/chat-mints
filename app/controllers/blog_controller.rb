class BlogController < ApplicationController
  include StoryObserver

  def show
    options = {
      attributes: true,
      lang: @locale,
      env: ENV['CONTENT_VERSIONS_ENV'],
    }

    begin
      @story = @mints_pub.get_story_version(params[:slug], options)['data']
    rescue Mints::Errors::ResourceNotFoundException => e
      redirect_to "/#{@locale}/#{I18n.t('routes.home.index' , { locale: @locale }) }"
    end
  end
end
