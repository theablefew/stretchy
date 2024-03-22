module Stretchy
    module Model
        module Persistence
            extend ActiveSupport::Concern

            class_methods do
                # Create a new instance and save it to the database.
                #
                # This class method is used to create a new instance of the model and save it to the database. It accepts a list of keyword attributes to set on the new instance.
                #
                # ### Parameters
                #
                # - `*args:` A list of keyword arguments representing the attributes to set on the new instance.
                #
                # ### Returns
                # Returns the newly created instance of the model.
                #
                # ---
                #
                # ### Examples
                #
                # #### Create a new instance
                #
                # ```ruby
                #   Model.create(name: 'John Doe', age: 30)
                # ```
                #
                def create(*args)
                    self.new(*args).save
                end
            end

            # Save the current instance to the database.
            #
            # This instance method is used to save the current instance of the model to the database. If the instance is a new record, it runs the `:create` callbacks and saves the instance to the database. It then sets the `id` of the instance to the `_id` returned by the save operation.
            #
            # ### Returns
            # Returns the `id` of the saved instance.
            #
            # ---
            #
            # ### Examples
            #
            # #### Save an instance
            #
            # ```ruby
            #   model = Model.new(name: 'John Doe', age: 30)
            #   model.save
            # ```
            #
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

            # Destroy the current instance.
            #
            # This instance method is used to delete the current instance of the model from the database. 
            # It differs from delete in that it runs the `:destroy` callbacks before deleting the instance.
            # 
            #
            # ### Returns
            # Returns `true` if the instance was successfully deleted, `false` otherwise.
            #
            # ---
            #
            # ### Examples
            #
            # #### Delete an instance
            #
            # ```ruby
            #   model = Model.find(id: '1')
            #   model.destroy
            # ```
            #
            def destroy
                run_callbacks :destroy do
                    delete
                end
            end

            # Delete the current instance from the database.
            #
            # This instance method is used to delete the current instance of the model from the database. It uses the `id` of the instance to perform the delete operation.
            #
            # ### Returns
            # Returns `true` if the instance was successfully deleted, `false` otherwise.
            #
            # ---
            #
            # ### Examples
            #
            # #### Delete an instance
            #
            # ```ruby
            #   model = Model.find(id: '1')
            #   model.delete
            # ```
            #
            def delete
                self.class.gateway.delete(self.id)["result"] == 'deleted'
            end

            # Update the current instance with the given attributes and save it to the database.
            #
            # This instance method is used to update the current instance of the model with the given attributes and save it to the database. It accepts a list of keyword arguments representing the attributes to update.
            #
            # ### Parameters
            #
            # - `*args:` A list of keyword arguments representing the attributes to update.
            #
            # ### Returns
            # Returns `true` if the instance was successfully updated, `false` otherwise.
            #
            # ---
            #
            # ### Examples
            #
            # #### Update an instance
            #
            # ```ruby
            #   model = Model.find(id: '1')
            #   model.update(name: 'Jane Doe', age: 32)
            # ```
            #
            def update(*args)
                run_callbacks :update do
                    self.assign_attributes(*args)
                    self.save
                end
            end

        end
    end
end
