# Salapi

## Notes/TODO

**WORK IN PROGRESS - I HIGHLY ADVISE AGAINST USING THIS.**

**TODO:**

- :x: Split `client` class into `machine` and `client` (all helper methods, `apps_list`, `search`).
- :x: Add HTTP response code analysis function with code-specific exceptions/retries.
- :heavy_check_mark: RSpec tests for nil required authentication values (sal_url, keys)
- :x: Add `machine_create` function
- :x: Add `machine_group_create` function
- :x: Add `machine_group_delete` function
- :x: Add `machine_group_info` function
- :x: Add `machine_group_list` function
- :x: Add `business_unit_create` function
- :x: Add `business_unit_delete` function
- :x: Add `business_unit_info` function
- :x: Add `business_unit_list` function
- :x: Add `plugin_script_info` function
- :x: Add `plugin_script_list` function
- :x: Add `plugin_script_row` function
- :x: Add `search_saved` function
- :x: Write RSpec tests for everything...

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
