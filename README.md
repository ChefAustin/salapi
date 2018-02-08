# Salapi

WORK IN PROGRESS - I HIGHLY ADVISE AGAINST USING THIS.

A simple Ruby wrapper for the [Sal API](https://github.com/salopensource/sal) written as an initial dive into gem creation.

## Install

Add this line to your application's Gemfile:

`gem 'salapi', :git => "https://github.com/ChefAustin/salapi.git"`

Run:

`$ bundle install`

## Setup

Set the following environment variables:

- 'SAL_PRIV_KEY' (API Private Key)
- 'SAL_PUB_KEY' (API Public Key)
- 'SAL_URL' (e.g. https://sal.megacorp.com)

## Available Actions

- machine_list
- machine_info
- machine_facts
- machine_conditions
- machine_apps
- machine_delete
- apps_list
- search

## Example


```
require 'salapi'

# Instantiate
client = SalAPI::Client.new

# Gather node serial list
fleet = client.machine_list

# Metrics to report back from machines
requested_metrics = ["hostname", "console_user", "serial", "operating_system", "deployed"]

# Report back
fleet.each do |box|
  info = client.machine_info(box.to_s)
  requested_metrics.each do |metric|
    p info[metric]
  end
end

```

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/chefaustin/salapi.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
