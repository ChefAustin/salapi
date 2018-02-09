# ./lib/salapi/client.rb
# TODO: Deal with pagination
#

module SalAPI
  # This is a top-level class comment (Happy now, RuboCop?!)
  class Client
    def initialize(priv_key = nil, pub_key = nil, sal_url = nil)
      @priv_key = priv_key || ENV['SAL_PRIV_KEY']
      @pub_key = pub_key || ENV['SAL_PUB_KEY']
      @sal_url = sal_url || ENV['SAL_URL']
      @sal_headers =
        { 'publickey' => @pub_key.to_s, 'privatekey' => @priv_key.to_s }
    end

    # Helper method; handles retrieval and parsing
    def get_json_response_body(endpoint_url)
      JSON.parse((HTTParty.get(endpoint_url, headers: @sal_headers)).body)
    end

    # Helper method; handles pagination logic
    def pg_clc(first_page)
      (get_json_response_body(first_page)['count'].to_f / 100.0).ceil
    end

    # Helper method; handles paginated data
    def paginator(request_url, total_pages)
      i = 1
      complete = []
      while i <= total_pages
        pg = HTTParty.get("#{request_url}/?page=#{i}", headers: @sal_headers)
        pg["results"].each do |h|
          complete << h
        end
        i += 1
      end
      complete
    end

    # Returns a hash of machine attributes
    def machine_info(serial)
      url = "#{@sal_url}/api/machines/#{serial}"
      get_json_response_body(url)
    end

    # TODO: This
    def machine_delete(serial)
      url = "#{@sal_url}/api/machines/#{serial}"
      get_json_response_body(url)
    end

    # Returns a paginated array of hashes
    def apps_list
      url = "#{@sal_url}/api/inventory"
      get_json_response_body(url)
    end

    # Returns an array of strings (serial numbers)
    def machine_list
      url = "#{@sal_url}/api/machines"
      pg_clc(url) >= 2 ? (paginator(url, pg_clc(url))) : (get_json_response_body(url)["results"])
    end

    # Returns a complete hash of Facter facts
    def machine_facts(serial)
      url = "#{@sal_url}/api/facts/#{serial}"
      pg_clc(url) >= 2 ? (paginator(url, pg_clc(url))) : (get_json_response_body(url)["results"])
    end

    # TODO: Check this; broken.
    # Returns a complete array of hashes
    def machine_conditions(serial)
      url = "#{@sal_url}/api/conditions/#{serial}"
      pg_clc(url) >= 2 ? (paginator(url, pg_clc(url))) : (get_json_response_body(url)["results"])
    end

    # Returns a complete array of hashes
    def machine_apps(serial)
      url = "#{@sal_url}/api/machines/#{serial}/inventory"
      pg_clc(url) >= 2 ? (paginator(url, pg_clc(url))) : (get_json_response_body(url)["results"])
    end

    # Returns an array of hashes
    def search(query)
      url = "#{@sal_url}/api/search/?query=#{query}"
      pg_clc(url) >= 2 ? (paginator(url, pg_clc(url))) : (get_json_response_body(url)["results"])
    end
  end
end
