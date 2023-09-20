module StoryObserver
    
    private

    def render(*args)
        if action_name === 'show' and @story
            update_meta_tags(
              @story['social_metadata'],
              @story['title'],
              (@story['blurb'] || ''),
              (@story['blurb'] || '') + ' ' + @story['title']
            )
        end

        super
    end
end