module Stretchy
    module Persistence
        extend ActiveSupport::Concern

        class_methods do
            def create(*args)
                self.new(*args).save
            end
        end

        def save
            run_callbacks :save do
                if new_record?
                    run_callbacks :create do
                        response = self.class.gateway.save(self.attributes)
                        self.id = response['_id']
                    end
                else
                    self.class.gateway.save(self.attributes)
                end
                self
            end
        end

        def destroy
            run_callbacks :destroy do
                delete
            end
        end

        def delete
            self.class.gateway.delete(self.id)["result"] == 'deleted'
        end

        def update(*args)
            run_callbacks :update do
                self.assign_attributes(*args)
                self.save
            end
        end

    end
end