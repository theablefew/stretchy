module Stretchy
    module Indexing
        module Bulk
            extend ActiveSupport::Concern

            class_methods do

                def bulk(records)
                    gateway.client.bulk body: records
                end

                # bulk_in_batches(records, size: 100) do |batch|
                #   # do something with the batch
                #   batch.each { |record| record.to_bulk(method)}
                # end
                def bulk_in_batches(records, size: 1000)
                    bulk_results = records.each_slice(size).map do |batch|
                        yield batch if block_given?
                        bulk(batch)
                    end
                    refresh_index!
                    bulk_results
                end


            end

            # TODO: May only be needed for associations
            def update_all(**attributes)
                # self.class.bulk_in_batches(self.all, size: 1000, method: :update) do |batch|
                #     batch.map! { |record| attributes.each { |key, value| record.send("#{key}=", value) } }
                # end
            end

            def to_bulk(method = :index)
                case method
                when :index
                  { index: { _index: self.class.gateway.index, data: self.as_json.except(:id) } }
                when :delete
                  { delete: { _index: self.class.gateway.index, _id: self.id } }
                when :update
                  { update: { _index: self.class.gateway.index, _id: self.id, data: { doc: self.as_json.except(:id) } } }
                end
            end

        end
    end
end