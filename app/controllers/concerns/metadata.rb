module Metadata
    extend ActiveSupport::Concern

    included do
        before_action :initialize_metadata
    end

    private

    def initialize_metadata
        current_url = request.original_url
        @meta_tags = {
            title: @implementation_title,
            description: @implementation_title,
            keywords: @implementation_title + ',' + @implementation_title.split(" ").join(","),
            social_tags: [{
                og: {
                    title: @implementation_title,
                    url: current_url,
                    description: @implementation_title,
                    image: nil,
                    type: "website"
                },
                twitter: {
                    card: "summary",
                    title: @implementation_title,
                    url: current_url,
                    description: @implementation_title,
                    image: nil
                }
            }]
        }
    end
    
    def update_meta_tags(metadata, title = '', description = '', keywords = '')
        @meta_tags[:title] += (" | " + title)
        @meta_tags[:description] += (" " + description)
        @meta_tags[:keywords] += (',' + keywords + ',' + keywords.split(" ").join(","))

        open_graph_tags = metadata['open_graph'] || {"meta_image": {}}.as_json
        twitter_tags = metadata['twitter'] || {"meta_image": {}}.as_json
        current_url = request.original_url

        @meta_tags[:social_tags] = [{
            og: {
                title: open_graph_tags['title'],
                url: current_url,
                description: open_graph_tags['description'],
                image: build_image_url(open_graph_tags),
                type: open_graph_tags['type'].empty? ? "website" : open_graph_tags['type']
            },
            twitter: {
                card: "summary",
                title: twitter_tags['title'],
                url: current_url,
                description: twitter_tags['title'],
                image: build_image_url(twitter_tags),
            }
        }]
    end

    def build_image_url(tags)
        tags['meta_image'] && tags['meta_image']['slug'] ? request.base_url + '/public-assets/' + tags['meta_image']['slug'] : nil
    end
end