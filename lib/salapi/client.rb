# ./lib/salapi/client.rb
#

module SalAPI
  # This is a top-level class comment (Happy now, RuboCop?!)
  class Client
    # Sets configuration instance variables
    def initialize(priv_key = nil, pub_key = nil, sal_url = nil)
      @priv_key = priv_key
      @pub_key = pub_key
      @sal_url = sal_url
      raise ArgumentError if @sal_url.nil?
      @sal_headers =
        { 'publickey' => @pub_key,
          'privatekey' => @priv_key,
          'Content-Type' => 'application/json' }
      raise ArgumentError if @sal_headers.values.any?(&:nil?)
    end

    # Helper Methods
    # Handles retrieval and parsing
    # TODO: Fix; Broken Right now
    def json_resp_body(endpoint_url)
      response = HTTParty.get(endpoint_url, headers: @sal_headers).parsed_response
      JSON.parse(response.body)
    end

    # Helper method; handles page count calculation (based on 100 items/page)
    def pg_clc(first_page)
      response = HTTParty.get(first_page, headers: @sal_headers).parsed_response
      (response['count'].to_f / 100.0).ceil
    end

    # Helper method; handles paginated data
    def paginator(request_url, pages, i = 1)
      build_array = []
      while i <= pages
        pg = HTTParty.get("#{request_url}?page=#{i}", headers: @sal_headers)
        build_array << pg.parsed_response['results']
        i += 1
      end
      build_array.flatten
    end

    def post_request(url, business_unit_name)
      post_body = { name: business_unit_name.to_s }.to_json
      response = HTTParty.post(url, body: post_body, headers: @sal_headers)
      response.parsed_response
    end

    def patch_request()
    end

    def delete_request(url)
      HTTParty.delete(url, headers: @sal_headers)
    end

    def put_request()
    end

    ### BUSINESS UNIT ENDPOINTS
    # Returns a hash of attributes for the new business unit
    def business_units_create(name)
      url = "#{@sal_url}/api/v2/business_units/"
      post_request(url, name)
    end

    # TODO: Use HTTP DELETE
    def business_units_delete(id)
      url = "#{@sal_url}/api/v2/business_units/#{id}/"
      delete_request(url)
    end

    # Returns an array of hashes (business units)
    def business_units_list
      url = "#{@sal_url}/api/v2/business_units/"
      json_resp_body(url)['results']
    end

    # TODO: Add comment
    # TODO: User HTTP PATCH
    def business_units_partial_update(id)
      url = "#{@sal_url}/api/v2/business_units/#{id}/"
      json_resp_body(url)
    end

    # Returns an array of machine's attribute hashes
    def business_units_read(id)
      url = "#{@sal_url}/api/v2/business_units/#{id}/"
      json_resp_body(url)
    end

    # TODO: Add comment
    # TODO: User HTTP PUT
    def business_units_update(id)
      url = "#{@sal_url}/api/v2/business_units/#{id}/"
      json_resp_body(url)
    end

    ### CONDITIONS ENDPOINTS
    # Returns a nested array
    def conditions_list
      url = "#{@sal_url}/api/v2/conditions/"
      pg_clc(url) == 1 ? json_resp_body(url)['results'] : paginator(url, pg_clc(url))
    end

    # Returns a hash for the given condition
    def conditions_read(id)
      url = "#{@sal_url}/api/v2/conditions/#{id}/"
      json_resp_body(url)
    end

    # FACTS ENDPOINTS
    # TODO: Fix this; seems to time-out
    def facts_list
      url = "#{@sal_url}/api/v2/facts/"
      pg_clc(url) == 1 ? json_resp_body(url)['results'] : paginator(url, pg_clc(url))
    end

    # TODO: Need to test this
    def facts_read(id)
      url = "#{@sal_url}/api/v2/facts/#{id}/"
      json_resp_body(url)
    end

    # INVENTORY ENDPOINTS
    # TODO: Seems to time-out
    # TODO: Add comment
    def inventory_list
      url = "#{@sal_url}/api/v2/inventory/"
      pg_clc(url) == 1 ? json_resp_body(url)['results'] : paginator(url, pg_clc(url))
    end

    # Returns a nested hash for the given inventory item
    def inventory_read(id)
      url = "#{@sal_url}/api/v2/inventory/#{id}/"
      json_resp_body(url)
    end

    ### MACHINE GROUP ENDPOINTS
    # TODO: Add Comment
    # TODO: Use HTTP POST and pass needed args
    def machine_groups_create(business_unit, name)
      url = "#{@sal_url}/api/v2/machine_groups/"
      json_resp_body(url, business_unit, name)
    end

    # TODO: Add Comment
    # TODO: Use HTTP DELETE
    def machine_groups_delete(id)
      url = "#{@sal_url}/api/v2/machine_groups/#{id}/"
      json_resp_body(url)
    end

    # Returns an array of hashes (machines groups)
    def machine_groups_list
      url = "#{@sal_url}/api/v2/machine_groups/"
      pg_clc(url) == 1 ? json_resp_body(url)['results'] : paginator(url, pg_clc(url))
    end

    # TODO: Add comment
    # TODO: User HTTP PATCH
    def machine_groups_partial_update(id)
      url = "#{@sal_url}/api/v2/machine_groups/#{id}/"
      json_resp_body(url)
    end

    # Returns a hash of the machine group attributes
    def machine_groups_read(id)
      url = "#{@sal_url}/api/v2/machine_groups/#{id}/"
      json_resp_body(url)
    end

    # TODO: Add comment
    # TODO: User HTTP PUT
    def machine_groups_update(id)
      url = "#{@sal_url}/api/v2/machine_groups/#{id}/"
      json_resp_body(url)
    end


    ### MACHINES ENDPOINTS
    # TODO: Add Comment
    # TODO: Use HTTP POST with proper arg passing
    def machines_create(serial)
      url = "#{@sal_url}/api/v2/machines/"
      json_resp_body(url, serial)
    end

    # TODO: Add comment
    # TODO: Use HTTP DELETE
    def machines_delete(serial)
      url = "#{@sal_url}/api/v2/machines/#{serial}/"
      json_resp_body(url)
    end

    # Returns an array of hashes (machines)
    def machines_list
      url = "#{@sal_url}/api/v2/machines/"
      pg_clc(url) == 1 ? json_resp_body(url)['results'] : paginator(url, pg_clc(url))
    end

    # TODO: Add comment
    # TODO: User HTTP PATCH
    def machines_partial_update(serial)
      url = "#{@sal_url}/api/v2/machines/#{serial}/"
      json_resp_body(url)
    end

    # Returns an array of machine's attribute hashes
    def machines_read(serial)
      url = "#{@sal_url}/api/v2/machines/#{serial}/"
      json_resp_body(url)
    end

    # TODO: Add comment
    # TODO: User HTTP PUT
    def machines_update(serial)
      url = "#{@sal_url}/api/v2/machines/#{serial}/"
      json_resp_body(url)
    end

    ### PENDING APPLE UPDATES ENDPOINT
    # Returns an array of hashes (Apple updates)
    def pending_apple_updates_list
      url = "#{@sal_url}/api/v2/pending_apple_updates/"
      pg_clc(url) == 1 ? json_resp_body(url)['results'] : paginator(url, pg_clc(url))
    end

    # Returns a hash for given Apple update
    def pending_apple_updates_read(id)
      url = "#{@sal_url}/api/v2/pending_apple_updates/#{id}/"
      json_resp_body(url)
    end

    ### PENDING UPDATES ENDPOINT
    # Returns an array of hashes (Updates)
    def pending_updates_list
      url = "#{@sal_url}/api/v2/pending_updates/"
      pg_clc(url) == 1 ? json_resp_body(url)['results'] : paginator(url, pg_clc(url))
    end

    # Returns a hash for the given update
    def pending_updates_read(id)
      url = "#{@sal_url}/api/v2/pending_updates/#{id}/"
      json_resp_body(url)
    end

    ### PLUGIN SCRIPT ROWS ENDPOINT
    # Returns the first page
    def plugin_script_rows_list
      url = "#{@sal_url}/api/v2/plugin_script_rows/"
      #pg_clc(url) == 1 ? json_resp_body(url)['results'] : paginator(url, pg_clc(url))
      json_resp_body(url)
    end

    # Returns a nested hash for given plugin script row
    def plugin_script_rows_read(id)
      url = "#{@sal_url}/api/v2/plugin_script_rows/#{id}/"
      json_resp_body(url)
    end

    ### SAVED SEARCHES ENDPOINT
    # Returns an array of hashes (saved searches)
    def saved_searches_list
      url = "#{@sal_url}/api/v2/saved_searches/"
      pg_clc(url) == 1 ? json_resp_body(url)['results'] : paginator(url, pg_clc(url))
    end

    # Returns a hash of the given saved search
    def saved_searches_read(id)
      url = "#{@sal_url}/api/v2/saved_searches/#{id}/"
      json_resp_body(url)
    end

    # Executes the saved search and returns an array of hashes (machines)
    def saved_searches_execute(id)
      url = "#{@sal_url}/api/v2/saved_searches/#{id}/execute/"
      json_resp_body(url)
    end
  end
end
