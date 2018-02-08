# ./lib/salapi/client.rb

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

    # TODO: Deal with pagination
    def machine_list
      url = "#{@sal_url}/api/machines"
      response = HTTParty.get(url, headers: @sal_headers)
      JSON.parse(response.body)
    end

    def machine_info(serial)
      url = "#{@sal_url}/api/machines/#{serial}"
      response = HTTParty.get(url, headers: @sal_headers)
      JSON.parse(response.body)
    end

    def machine_facts(serial)
      url = "#{@sal_url}/api/facts/#{serial}"
      response = HTTParty.get(url, headers: @sal_headers)
      JSON.parse(response.body)
    end

    def machine_conditions(serial)
      url = "#{@sal_url}/api/conditions/#{serial}"
      response = HTTParty.get(url, headers: @sal_headers)
      JSON.parse(response.body)
    end

    def machine_apps(serial)
      url = "#{@sal_url}/api/machines/#{serial}/inventory"
      response = HTTParty.get(url, headers: @sal_headers)
      JSON.parse(response.body)
    end

    def machine_delete(serial)
      url = "#{@sal_url}/api/machines/#{serial}"
      response = HTTParty.delete(url, headers: @sal_headers)
      JSON.parse(response.body)
    end

    def apps_list
      url = "#{@sal_url}/api/inventory"
      response = HTTParty.get(url, headers: @sal_headers)
      JSON.parse(response.body)
    end

    def search(query)
      url = "#{@sal_url}/api/search/?query=#{query}"
      response = HTTParty.get(url, headers: @sal_headers)
      JSON.parse(response.body)
    end
  end
end
