module Stretchy
  class Pipeline
    cattr_reader :client do 
      Stretchy.configuration.client.ingest 
    end

    class << self
      attr_accessor :description, :pipeline_name, :processors

      def pipeline_name(name = nil)
        return @pipeline_name if name.nil? && @pipeline_name
        @pipeline_name = name || self.name.split('::').last.underscore
      end

      def description(desc = nil)
        @description = desc if desc
        @description
      end

      def processor(type, opts = {})
        @processors ||= []
        @processors << Stretchy::Pipelines::Processor.new(type, opts)
      end

      def all
        begin
          client.get_pipeline
        rescue not_found => e
          return {}
        end
      end
    
      def find(id)
        client.get_pipeline(id: id)
      end

      def simulate(docs, verbose: true)
        client.simulate(id: self.pipeline_name, body: {docs: docs}, verbose: verbose)
      end

      # PUT _ingest/pipeline/<pipeline-name>
      def create!
        client.put_pipeline(id: self.pipeline_name, body: self.to_hash)
      end

      # DELETE _ingest/pipeline/<pipeline-name>
      def delete!
        client.delete_pipeline(id: self.pipeline_name)
      end

      def exists?
        begin
          self.find(self.pipeline_name).present?
        rescue not_found => e
          return false
        end
      end


      def to_hash
        {
          description: self.description,
          processors: self.processors.map(&:to_hash)
        }.as_json
      end

      protected 
      def not_found
        @not_found ||= Object.const_get("#{client.class.name.split('::').first}::Transport::Transport::Errors::NotFound") 
      end

    end

    attr_accessor :description, :pipeline_name, :processors

    def initialize
      @description = self.class.description
      @pipeline_name = self.class.pipeline_name
      @processors = self.class.processors
    end

    # GET _ingest/pipeline/<pipeline-name>
    def find
      self.class.find(self.pipeline_name)
    end

    # Simulates the pipeline.
    #
    # Request body fields
    #
    # The following table lists the request body fields used to run a pipeline.
    #
    # Field	Required	Type	Description
    # docs	Required	Array	The documents to be used to test the pipeline.
    # pipeline	Optional	Object	The pipeline to be simulated. If the pipeline identifier is not included, then the response simulates the latest pipeline created.
    # The docs field can include subfields listed in the following table.
    #
    # Field	Required	Type	Description
    # source	Required	Object	The document’s JSON body.
    # id	Optional	String	A unique document identifier. The identifier cannot be used elsewhere in the index.
    # index	Optional	String	The index where the document’s transformed data appears.
    def simulate(docs, verbose: true)
      self.class.simulate(docs, verbose: verbose)
    end
    
    def exists?
      self.class.exists?
    end

    def to_hash
      {
        description: self.description,
        processors: self.processors.map(&:to_hash)
      }.as_json
    end

    def client
      @client ||= Stretchy.configuration.client.ingest
    end


  end
end
