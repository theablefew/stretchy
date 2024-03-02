module Stretchy
    module Utils
        extend ActiveSupport::Concern

        class_methods do

            def to_curl(arguments = {}, end_point = "_search")
                host = gateway.client.transport.transport.hosts&.first || gateway.client.transport.transport.options[:url]
                arguments[:index] = "_all" if !arguments[:index] && arguments[:type]

                valid_params = [
                    :analyzer,
                    :analyze_wildcard,
                    :default_operator,
                    :df,
                    :explain,
                    :fields,
                    :from,
                    :ignore_indices,
                    :ignore_unavailable,
                    :allow_no_indices,
                    :expand_wildcards,
                    :lenient,
                    :lowercase_expanded_terms,
                    :preference,
                    :q,
                    :routing,
                    :scroll,
                    :search_type,
                    :size,
                    :sort,
                    :source,
                    :_source,
                    :_source_include,
                    :_source_exclude,
                    :stats,
                    :suggest_field,
                    :suggest_mode,
                    :suggest_size,
                    :suggest_text,
                    :timeout,
                    :version,
                ]

                method = "GET"
                path = Elasticsearch::API::Utils.__pathify(Elasticsearch::API::Utils.__listify(arguments[:index]), end_point)

                params = Elasticsearch::API::Utils.__validate_and_extract_params arguments, valid_params
                body = arguments[:body]

                params[:fields] = Elasticsearch::API::Utils.__listify(params[:fields]) if params[:fields]

                url = path

                unless host.is_a? String
                    host_parts = "#{host[:protocol].to_s}://#{host[:host]}"
                    host_parts = "#{host_parts}:#{host[:port]}" if host[:port]
                else
                    host_parts = host
                end

                trace_url = "#{host_parts}/#{url}"
                trace_url += "?#{::Faraday::Utils::ParamsHash[params].to_query}" unless params.blank?
                trace_body = body ? " -d '#{body.to_json}'" : ""

                Rainbow("curl -X #{method.to_s.upcase} '#{CGI.unescape(trace_url)}'#{trace_body}\n").color :white
            end

        end
    end
end