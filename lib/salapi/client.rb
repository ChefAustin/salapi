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

    # Helper method; handles paginated responses (100/page)
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

    # Returns an array of serials
    def machine_list
      url = "#{@sal_url}/api/machines"
      response = HTTParty.get(url, headers: @sal_headers)
      json = JSON.parse(response.body)
      pages = (json['count'].to_f / 100.0).ceil
      if json["next"].nil? == false
        rtr = paginator(url, pages).map { |h| h["serial"] }
      else
        rtr = json["results"]
      end
      rtr
    end

    # Returns a hash of machine attributes
    def machine_info(serial)
      url = "#{@sal_url}/api/machines/#{serial}"
      response = HTTParty.get(url, headers: @sal_headers)
      JSON.parse(response.body)
    end

    # Returns a hash of
    def machine_facts(serial)
      url = "#{@sal_url}/api/facts/#{serial}"
      response = HTTParty.get(url, headers: @sal_headers)
      json = JSON.parse(response.body)
      pages = (json['count'].to_f / 100.0).ceil
      if json["next"].nil? == false
        rtr = paginator(url, pages)
      else
        rtr = json["results"]
      end
      rtr
    end

    def machine_conditions(serial)
      url = "#{@sal_url}/api/conditions/#{serial}"
      response = HTTParty.get(url, headers: @sal_headers)
      json = JSON.parse(response.body)
      pages = (json['count'].to_f / 100.0).ceil
      if json["next"].nil? == false
        rtr = paginator(url, pages)
      else
        rtr = json["results"]
      end
      rtr
    end

    def machine_apps(serial)
      url = "#{@sal_url}/api/machines/#{serial}/inventory"
      response = HTTParty.get(url, headers: @sal_headers)
      json = JSON.parse(response.body)
      pages = (json['count'].to_f / 100.0).ceil
      if json["next"].nil? == false
        rtr = paginator(url, pages)
      else
        rtr = json["results"]
      end
      rtr
    end

    def machine_delete(serial)
      url = "#{@sal_url}/api/machines/#{serial}"
      response = HTTParty.delete(url, headers: @sal_headers)
      JSON.parse(response.body)
    end

    def apps_list
      url = "#{@sal_url}/api/inventory"
      response = HTTParty.get(url, headers: @sal_headers)
      json = JSON.parse(response.body)
      pages = (json['count'].to_f / 100.0).ceil
      if json["next"].nil? == false
        rtr = paginator(url, pages)
      else
        rtr = json["results"]
      end
      rtr
    end

    def search(query)
      url = "#{@sal_url}/api/search/?query=#{query}"
      response = HTTParty.get(url, headers: @sal_headers)
      json = JSON.parse(response.body)
      pages = (json['count'].to_f / 100.0).ceil
      if json["next"].nil? == false
        rtr = paginator(url, pages)
      else
        rtr = json["results"]
      end
      rtr
    end
  end
end
