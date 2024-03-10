module Stretchy
    module Utils
        extend ActiveSupport::Concern

            concerning :ConsoleMethods do
                def reload!
                    Stretchy.loader.reload
                end

                def banner
                    banner = <<~BANNER
                                    
                                                                    d8b                
                               d8P                     d8P          ?88                
                            d888888P                d888888P         88b               
                     .d888b,  ?88'    88bd88b d8888b  ?88'   d8888b  888888b ?88   d8P 
                     ?8b,     88P     88P'  `d8b_,dP  88P   d8P' `P  88P `?8bd88   88  
                       `?8b   88b    d88     88b      88b   88b     d88   88P?8(  d88  
                    `?888P'   `?8b  d88'     `?888P'  `?8b  `?888P'd88'   88b`?88P'?8b 
                                                                                    )88
                                                                                   ,d8P
                                                                                `?888P'
                    BANNER
                end
            end

            def self.to_curl(klass, arguments = {}, end_point = "_search")
                host = klass.gateway.client.transport.transport.hosts&.first || klass.gateway.client.transport.transport.options[:url]
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

                "curl -X#{method.to_s.upcase} '#{CGI.unescape(trace_url)}'#{trace_body}\n"
            end

    end
end