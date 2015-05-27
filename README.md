# HashSelector

Select values from deeply nested/complex hashes with ease.

## Usage

Consider a complex and deeply nested hash such as the following:

```ruby
config =
{ databases: [
    { name: "myapp_production",
      user: "myapp",
      host: "db1"
    },
    { name: "legacy_db",
      host: "db2"
    }
  ],
  "redis": { host: "redis_server" }
}
```

Say we want to find the user name of legacy db but if we do not find it use a default value. With just the basic hash behavior this can be rather onerous. With `HashSelector` is it a breeze.

```ruby
selector = HashSelector.new[:databases].find{|db| db[:name] == "myapp_production"}[:user]
selector.find_in(config) # => "myapp"
```
The selector definition line should be read as "a new selector that chooses the `:databases` item, finds an entry in it whose name is `myapp_production`, and selects its `:user`"

If the location specified by a `HashSelector` does not exist the hash it will raise a `KeyError` unless a block is provided. If a block is provided the block will be evaluated and its return value will returned from `#find_in`.

```ruby
selector = HashSelector.new[:databases].find{|db| db[:name] == "myapp_test"}[:user]
selector.find_in(config) { "myapp" } # => "myapp"
```

In this example, there find fails because there is not entry in `:databases` with a name of `myapp_test` so the default (`myapp`) is returned instead.

`HashSelector`s are immutable and may be reused any any number of different hashes.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'hash-selector'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install hash-selector



## Contributing

1. Fork it ( https://github.com/[my-github-username]/hash_selector/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
