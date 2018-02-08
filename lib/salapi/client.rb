# ./lib/salapi/client.rb

module SalAPI
  # This is a top-level class comment
  class Client
    def initialize(priv_key = nil, pub_key = nil)
      @priv_key = priv_key || ENV['SAL_PRIV_KEY']
      @pub_key = pub_key || ENV['SAL_PUB_KEY']
    end

    def machines_list
      url = 'https://mr.gustocorp.com/api/machines'
      response = HTTParty.get(url, headers:
        {
          'publickey' => "#{@pub_key}",
          'privatekey' => "#{@priv_key}"
        })
      JSON.parse(response.body)
    end

  end
end
