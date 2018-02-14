# Salapi

## Notes/TODO

**WORK IN PROGRESS - I HIGHLY ADVISE AGAINST USING THIS.**

## Description

A simple Ruby wrapper for the [Sal API](https://github.com/salopensource/sal) written as an initial dive into gem creation.

## Install

Add this line to your application's Gemfile:

`gem 'salapi', :git => "https://github.com/ChefAustin/salapi.git"`

Run:

`$ bundle install`


## Available Actions

- apps_list
- machine_apps
- machine_attribute
- machine_conditions
- machine_delete
- machine_facts
- machine_info
- machine_list
- machine_undeploy
- search

## Example


```
require 'salapi'

# Instantiate
client = SalAPI::Client.new("PublicKey", "PrivateKey", "https://sal.supercorp.com")

# Gather machine serial list
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
