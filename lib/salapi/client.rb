# ./lib/salapi/client.rb
#

module SalAPI
  # This is a top-level class comment (Happy now, RuboCop?!)
  class Client

    def initialize(priv_key = nil, pub_key = nil, sal_url = nil)
      @priv_key = priv_key
      @pub_key = pub_key
      @sal_url = sal_url
      raise ArgumentError if @sal_url.nil?
      @sal_headers =
          { 'publickey' => @pub_key.to_s,
            'privatekey' => @priv_key.to_s,
            "Content-Type" => "application/json" }
      raise ArgumentError if @sal_headers.values.any?(&:nil?)
    end

    # Helper method; handles retrieval and parsing
    def json_resp_body(endpoint_url)
      JSON.parse((HTTParty.get(endpoint_url, headers: @sal_headers)).body)
    end

    # Helper method; handles machine attribute updates
    def machine_patch(machine_url, kwargs)
      response = HTTParty.patch(
        machine_url,
        :headers => @sal_headers,
        :body => kwargs.to_json)
      response
    end

    # Helper method; handles page count calculation (based on 100 items/page)
    def pg_clc(first_page)
      (json_resp_body(first_page)['count'].to_f / 100.0).ceil
    end

    # Helper method; handles paginated data
    def paginator(request_url, total_pages, i = 1)
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

    # Returns a desired, specified attribute key-value for given machine
    def machine_attribute(serial, attribute)
      url = "#{@sal_url}/api/machines/#{serial}"
      json_resp_body(url)["#{attribute}"]
    end

    # Returns a hash of machine attributes
    def machine_info(serial)
      url = "#{@sal_url}/api/machines/#{serial}"
      json_resp_body(url)
    end

    # Sets a machine's 'Deploy Status' to undeployed
    def machine_undeploy(serial)
      url = "#{@sal_url}/api/machines/#{serial}/"
      response = machine_patch(url, {'deployed' => false})
      if response.code == 200
        machine_info(serial)["deployed"] ? ("Failed.") : ("Success.")
      else
        p "Undeploy of #{serial} failed with code: #{response.code}"
      end
    end

    # Removes a machine entry from Sal dB;
    def machine_delete(serial)
      url = "#{@sal_url}/api/machines/#{serial}"
      json_resp_body(url)
    end

    # Returns a paginated array of hashes
    def apps_list
      url = "#{@sal_url}/api/inventory"
      json_resp_body(url)
    end

    # Returns an array of strings (serial numbers)
    def machine_list
      url = "#{@sal_url}/api/machines"
      pg_clc(url) >= 2 ? (paginator(url, pg_clc(url))) : (json_resp_body(url)["results"])
    end

    # Returns a complete hash of Facter facts
    def machine_facts(serial)
      url = "#{@sal_url}/api/facts/#{serial}"
      pg_clc(url) >= 2 ? (paginator(url, pg_clc(url))) : (json_resp_body(url)["results"])
    end

    # Returns a complete array of hashes
    def machine_conditions(serial)
      url = "#{@sal_url}/api/conditions/#{serial}"
      pg_clc(url) >= 2 ? (paginator(url, pg_clc(url))) : (json_resp_body(url)["results"])
    end

    # Returns a complete array of hashes
    def machine_apps(serial)
      url = "#{@sal_url}/api/machines/#{serial}/inventory"
      pg_clc(url) >= 2 ? (paginator(url, pg_clc(url))) : (json_resp_body(url)["results"])
    end

    # Returns an array of hashes
    def search(query)
      url = "#{@sal_url}/api/search/?query=#{query}"
      pg_clc(url) >= 2 ? (paginator(url, pg_clc(url))) : (json_resp_body(url)["results"])
    end
  end
end
