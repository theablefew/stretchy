module Stretchy
  module Relations
    module QueryMethods
      module Highlight
        extend ActiveSupport::Concern
        # Highlights search results on one or more fields.
        #
        # This method is used to highlight search results on one or more fields. The fields that match the user query get
        # highlighted. It accepts a variable number of arguments, each of which is the name of a field to be highlighted.
        #
        # ### Parameters
        #
        # - `field:` The Symbol of a field name to be highlighted by the query or a series of keyword hashes with the field name as the key and the highlight options as the value
        # - `options:` The Hash of highlight options
        #      - `boundary_chars:` The String of the boundary characters (default: ".,!? \t\n")
        #      - `boundary_max_scan:` The Integer of the maximum number of characters to scan to find the boundary characters (default: 20)
        #      - `boundary_scanner:` The String of the boundary scanner type (default: "sentence")
        #      	- "sentence" Breaks text into sentences
        #       - "word" Breaks text into words
        #       - "char" Breaks text into characters
        #      - `boundary_scanner_locale:` The String of the locale for the boundary scanner (default: "en-US")
        #      - `encoder:` The String of the encoder type (default: "default").
        #      - `fragmenter:` The String of the fragmenter type (default: "simple").
        #      - `force_source:` The Boolean to force highlighting on the source (default: false).
        #      - `fragment_offset:` The Integer of the number of characters to offset the fragment (default: 0).
        #      - `fragment_size:` The Integer of the number of characters in a fragment (default: 100).
        #      - `highlight_query:` The Hash of highlight query options (default: {}).
        #      - `matched_fields:` The Array of fields to be highlighted (default: []).
        #      - `no_match_size:` The Integer of the number of characters to return if no matches are found (default: 150).
        #      - `number_of_fragments:` The Integer of the number of fragments to return (default: 5).
        #      - `order:` The String of the order of the highlighted fragments (default: "score").
        #      - `phrase_limit:` The Integer of the maximum number of phrases to highlight (default: 256).
        #      - `pre_tags:` The String or Array of Strings to be used as the pre-highlight tags (default: "<em>").
        #      - `post_tags:` The String or Array of Strings to be used as the post-highlight tags (default: "</em>").
        #      - `require_field_match:` The Boolean to require field matching (default: true).
        #      - `max_analyzed_offset:` The Integer of the maximum number of characters to analyze (default: 1000000).
        #      - `tags_schema:` The String of the tags schema (default: "styled").
        #      - `type:` The String of the highlight type (default: "unified").
        #         * "unified" - Highlights fields based on the Unified Highlighter.
        #         * "plain" - Highlights fields based on the Plain Highlighter.
        #         * "fvh" - Highlights fields based on the Fast Vector Highlighter.
        #
        # ### Returns
        # Returns a new Stretchy::Relation with the specified fields to be highlighted.
        #
        # ---
        #
        # ### Examples
        #
        # #### Single field
		#
        # ```
        #  Model.query_string("body:Cat OR Lion").highlight(:body)
        # ```
		#
        # ### Custom highlight options
		#
        # ```ruby
        #  Model.query_string("name: Soph*").highlight(name: {pre_tags: "__", post_tags: "__"})
		# ```
        #
        def highlight(*args)
          spawn.highlight!(*args)
        end

        def highlight!(*args) # :nodoc:
          self.highlight_values += args
          self
        end

        QueryMethods.register!(:highlight)
      end
    end
  end
end
