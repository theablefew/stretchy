module Stretchy
    module Indexing
        module Bulk
            extend ActiveSupport::Concern

            class_methods do
                # used to bulk index a collection of records.
                #
                # ### Parameters
                #
                # - `records:` (Array) - The collection of records to be indexed.
                #
                # ### Returns
                #
                # - (Hash) - The response from Elasticsearch after performing the bulk operation.
                #
                # ### Behavior
                #
                # The method sends a bulk request to Elasticsearch with the provided records. The records should be an array of hashes, where each hash describes a single create, index, delete, or update operation.
                # It always returns the response from Elasticsearch.
                #
                # ### Example
                #
                # ```ruby
                # records = [
                #   { index: { _index: 'my_index', _id: 1, data: { title: 'foo' } } },
                #   { index: { _index: 'my_index', _id: 2, data: { title: 'bar' } } }
                # ]
                # MyModel.bulk(records)
                # ```
                # In this example, the `bulk` method is used to index two records into 'my_index'.
                def bulk(records)
                    self.gateway.client.bulk body: records
                end

                # used to bulk index a collection of records in batches.
                #
                # ### Parameters
                #
                # - `records:` (Array) - The collection of records to be indexed.
                # - `size:` (Integer) - The size of the batches. Defaults to 1000.
                # - `&block:` (optional) A block that is evaluated for each batch. This can be used to perform operations on each batch.
                #
                # ### Returns
                #
                # - (Array) - The results of the bulk operations.
                #
                # ### Behavior
                #
                # - The method splits the records into batches of the specified size. For each batch, if a block is given, it is evaluated with the batch as argument. Then, the batch is indexed using the `bulk` method.
                # - After all batches have been processed, it refreshes the index to make the changes available for search.
                #
                # ### Example
                #
                # ```ruby
                # records = [Report.new(title: "hello"), Report.new(title: "world"), Report.new(title: "goodbye")]
                # MyModel.bulk_in_batches(records, size: 100) do |batch|
                #   # do something with the batch
                #   batch.map! { |record| record.to_bulk(:index)}
                # end
                # ```
                # In this example, the `bulk_in_batches` method is used to index the `records` in batches of 100. 
                def bulk_in_batches(records, size: 1000)
                    bulk_results = records.each_slice(size).map do |batch|
                        yield batch if block_given?
                        bulk(batch)
                    end
                    self.refresh_index!
                    bulk_results
                end


            end

            # TODO: May only be needed for associations
            def update_all(**attributes)
                # self.class.bulk_in_batches(self.all, size: 1000, method: :update) do |batch|
                #     batch.map! { |record| attributes.each { |key, value| record.send("#{key}=", value) } }
                # end
            end

            # used to transform a record into a hash suitable for bulk operations.
            #
            # ### Parameters
            #
            # - `method:` (Symbol) - The operation to be performed. Can be `:index`, `:delete`, or `:update`. Defaults to `:index`.
            #
            # ### Returns
            #
            # - (Hash) - The hash representing the record for the bulk operation.
            #
            # ### Behavior
            #
            # The method transforms the record into a hash that describes the operation to be performed on the record. The operation is specified by the `method` parameter.
            # For `:index`, it includes the index name and the record data (excluding the id).
            # For `:delete`, it includes the index name and the record id.
            # For `:update`, it includes the index name, the record id, and the record data (excluding the id).
            #
            # ### Example
            #
            # ```ruby
            # record = MyModel.new(title: "hello")
            # record.to_bulk(:index)
            # # => { index: { _index: "my_models", data: { title: "hello" } } }
            # ```
            # In this example, the `to_bulk` method is used to transform a `MyModel` instance into a hash suitable for an index operation in a bulk request.
            def to_bulk(method = :index)
                case method
                when :index
                  { index: { _index: self.class.index_name, data: self.as_json.except(:id) } }
                when :delete
                  { delete: { _index: self.class.index_name, _id: self.id } }
                when :update
                  { update: { _index: self.class.index_name, _id: self.id, data: { doc: self.as_json.except(:id) } } }
                end
            end

        end
    end
end