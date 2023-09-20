module CaliforniaContentManager
  extend ActiveSupport::Concern

  included do
      # Get content bundle and call all content managers
      before_action :set_page_content
  end

  private

  def set_page_content
    #Get bundles depending on public folder filter
    pages_without_content = ENV.fetch('PAGES_WITHOUT_CXF_CONTENT', '').split(',')

    unless pages_without_content.include? controller_name or pages_without_content.include? "#{controller_name}:#{action_name}"
      bundle_options = {
        lang: @locale || 'es',
        env: ENV.fetch('CONTENT_VERSIONS_ENV', 'es'),
        status: ENV.fetch('CONTENT_VERSIONS_STATUS', 'published')
      }

      if ENV.fetch('USE_MULTI_LANGUAGE', false).to_s.downcase.strip === 'true'
        begin
          public_folder = @mints_pub.client.raw("get", "/config/public-folders/#{@controller_name_id}-#{@locale}", {object_type: 'content_pages' })['data']
          bundle_options[:pubfolder] = public_folder['id']
        rescue => e
          bundle_options = nil
        end

        if bundle_options
          @bundles = @mints_pub.client.raw("get", "/content/content-pages", bundle_options)['data']
          @page = @bundles.find{ |bundle| get_slug(bundle['slug']).include? "#{@controller_name_id}-page-#{@locale}" }
        else
          @page = {}
        end
      else
        begin
          @bundles = @mints_pub.client.raw("get", "/content/content-pages", bundle_options)['data']
          @page = @bundles.find{ |bundle| get_slug(bundle['slug']).include? @controller_name_id }
        rescue => e
          @page = {}
        end
      end

      if @page
        @header = @bundles&.find {|bundle| bundle['slug'].include? 'header'}
        @footer = @bundles&.find {|bundle| bundle['slug'].include? 'footer'}
      end

    end
  end

  def get_slug(slug)
    ActiveSupport::Inflector.transliterate(slug.downcase.strip)
  end

end