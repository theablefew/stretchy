require 'spec_helper'
require 'models/post'

describe "Instrumentation" do

    it 'subscribes to search.elasticsearch' do
        subscription = ActiveSupport::Notifications.subscribe 'search.elasticsearch' do |name, start, finish, id, payload|
            message = [
               payload[:klass], 
               "(#{(finish.to_time - start.to_time).round(2)}ms)",
               Stretchy::Utils.to_curl(payload[:klass].constantize, payload[:search])
            ].join(" ")
            expect(message).to match(/Post\(0.0ms\) curl -XGET 'https?:\/\/localhost:9200\/posts\/_search' -d '\{\"query\":\{\"term\":\{\"title\":\"hello\"\}\}\}'/)
        end
        ActiveSupport::Notifications.unsubscribe(subscription)
    end

    it 'converts the payload to a curl command' do
        curl = Stretchy::Utils.to_curl(Post, {index: Post.index_name, body: {query: {term: {title: "hello"}}}})
        expect(curl).to match(%r{curl -XGET 'https?://localhost:9200/posts/_search' -d '\{"query":\{"term":\{"title":"hello"\}\}\}'\n})
    end
end