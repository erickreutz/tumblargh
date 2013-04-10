module Tumblargh
  module Renderer
    module Blocks
      # Posts Loop
      #
      # {block:Posts} is executed once for each post. Some post related tags can
      # exist outside of a `type` block, such as {Title} or {Permalink}, so
      # they should be defined here
      class Posts < Base

        contextual_tag :post_id, :id
        contextual_tag :post_type, :type
        contextual_tag :title
        contextual_tag :tags_as_classes
        contextual_tag :caption

        def permalink
          url_path(context.post_url)
        end

        def perma
          url_path(context.url)
        end

        def permalink?
          context.permalink?
        end

        def post_notes_url
          # http://bikiniatoll.tumblr.com/notes/1377511430/vqS0xw8sm
          "/notes/#{context.id}/"
        end

        def reblog_url
          "/reblog/#{context.reblog_key}"
        end

        # An HTML class-attribute friendly list of the post's tags.
        # Example: "humor office new_york_city"
        #
        # By default, an HTML friendly version of the source domain of imported
        # posts will be included. This may not behave as expected with feeds
        # like Del.icio.us that send their content URLs as their permalinks.
        # Example: "twitter_com", "digg_com", etc.
        #
        # The class-attribute "reblog" will be included automatically if the
        # post was reblogged from another post.
        def tags_as_classes
          context.tags.map do |tag|
            tag.name.titlecase.gsub(/\s+/, '').underscore.downcase
          end.join " "
        end

        def post_for_permalink
          link = perma

          context.posts.each do |p|
            if url_path(p.post_url) == link
              return p
            end
          end
        end

        def render
          if context.is_a? Resource::Post
            super
          else
            posts = permalink? ? [post_for_permalink] : context.posts

            posts.map do |post|
              post.context = self
              self.class.new(node, post).render
            end.flatten.join('')
          end
        end

        private

          def url_path(url="")
            url.gsub(/^http:\/\/[^\/]+/, '')
          end

      end
    end
  end
end
