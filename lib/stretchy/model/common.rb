module Stretchy
    module Model
        module Common
            extend ActiveSupport::Concern

            # Get the highlighted results for a specific field.
            #
            # This method is used to get the highlighted results for a specific field from the search results. It accepts a field for which to get the highlighted results.
            #
            # ### Parameters
            #
            # - `field:` The Symbol or String representing the field for which to get the highlighted results.
            #
            # ### Returns
            # Returns an Array of Strings representing the highlighted results for the specified field.
            #
            # ---
            #
            # ### Examples
            #
            # #### Get the highlighted results for a field
            #
            # ```ruby
            #   result = Model.query_string("name: Soph*").highlight(name: {pre_tags: "__", post_tags: "__"}).first
            #   result.highlights_for(:name)
            # ```
            #
            def highlights_for(attribute)
                highlights[attribute.to_s]
            end

            class_methods do

                # Set or get the default sort key.
                #
                # This method is used to set or get the default sort key to be used in sort operations. If a field is provided, it sets the field as the default sort key. If no field is provided, it returns the current default sort key.
                #
                # `created_at` is the default sort key.
                #
                # ### Parameters
                #
                # - `field:` The Symbol or String representing the field to be used as the default sort key (optional).
                #
                # ### Returns
                # Returns the current default sort key if no field is provided. If a field is provided, it sets the field as the default sort key and returns the field.
                #
                # ---
                #
                # ### Examples
                #
                # #### Set the default sort key
                #
                # ```ruby
                #   class Model < StretchyModel
                #       default_sort_key :updated_at
                #   end
                # ```
                #
                # #### Get the default sort key
                #
                # ```ruby
                #   Model.default_sort_key
                # ```
                #
                def default_sort_key(field = nil)
                    @default_sort_key = field unless field.nil?
                    @default_sort_key
                end


                # Set or get the default size.
                #
                # This method is used to set or get the default size to be used in operations that return documents. If a size is provided, it sets the size as the default size. 
                # If no size is provided, it returns the current default size.
                # 
                # 10000 is the default size for StretchyModel
                #
                # ### Parameters
                #
                # - `size:` The Integer representing the size to be used as the default size (optional).
                #
                # ### Returns
                # Returns the current default size if no size is provided. If a size is provided, it sets the size as the default size and returns the size.
                #
                # ---
                #
                # ### Examples
                #
                # #### Set the default size
                #
                # ```ruby
                #   class Model < StretchyModel
                #       default_size 100
                #   end
                # ```
                #
                # #### Get the default size
                #
                # ```ruby
                #   Model.default_size
                # ```
                #
                def default_size(size = nil)
                    @default_size = size unless size.nil?
                    @default_size
                end

                
                # Set or get the default pipeline.
                #
                # This method is used to set or get the default pipeline at the index level to be used in operations that require a pipeline. 
                #  
                # If a pipeline is provided, it sets the pipeline as the default pipeline. 
                # If no pipeline is provided, it returns the current default pipeline.
                #
                # ### Parameters
                #
                # - `pipeline:` The String representing the pipeline to be used as the default pipeline (optional).
                #
                # ### Returns
                # Returns the current default pipeline if no pipeline is provided. If a pipeline is provided, it sets the pipeline as the default pipeline and returns the pipeline.
                #
                # ---
                #
                # ### Examples
                #
                # #### Set the default pipeline
                #
                # ```ruby
                #   class Model < StretchyModel
                #       default_pipeline 'my_pipeline'
                #   end
                # ```
                #
                # #### Get the default pipeline
                #
                # ```ruby
                #   Model.default_pipeline
                # ```
                #
                def default_pipeline(pipeline = nil)
                    @default_pipeline = pipeline.to_s unless pipeline.nil?
                    @default_pipeline
                end

                private

                # Return a Relation instance to chain queries
                #
                def relation
                    Relation.create(self, {})
                end

            end
        end
    end
end
