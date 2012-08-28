# yettings

YAML settings for your Rails 3 app.

## What does it do?

Yettings allows you to add a yml file to your "config" directory and you can access the values defined in the YAML in your Rails app.  You can
use this to store API keys, constants, and other key/value pairs.  This plugin was heavily inspired by settingslogic, with a few differences... You don't
have to add a class and point to the YML file.  The Yetting class will be created dynamically and will be available to your Rails app.  This plugin is also
more basic than settingslogic.  It does not have support for dynamic setting creation... only the values in the yetting.yml will be available.


## This project only supports Rails 3 and Ruby >= 1.9.2

There is a branch for 1.8.7, but it has not been merged into master. If you want to use it, you can reference the github location and branch in your Gemfile. See the issue tracker for more details

## Known bug in YAML psych parser (Ruby < 1.9.2-p271)
This bug can cause issues loading the YAML keys when using Yettings.  The workaround is to set your YAML parser to sych if your environment is currently using psych:

    YAML::ENGINE.yamler = "syck"

More info here:  http://pivotallabs.com/users/mkocher/blog/articles/1692-yaml-psych-and-ruby-1-9-2-p180-here-there-be-dragons

This issue is fixed in ruby-1.9.2-p271.

## Usage

###Install the gem

Add this to your Gemfile
  gem "yettings"

Install with Bundler
  bundle install

###Adding the YAML file with your key/value pairs

1. Create a YAML file inside /your_rails_app/config called yetting.yml
2. If you want to namespace your Yettings, create a YAML file inside /your_rails_app/config/yettings/ and call it whatever you want.

###YAML file content
You can define key/value pairs in the YAML file and these will be available in your app.  You can set the defaults and any environment specific values.
The file must contain each environment that you will use in your Rails app.  Here is a sample:

  defaults: &defaults
    api_key: asdf12345lkj
    some_number: 999
    an_erb_yetting: <%= "erb stuff works" %>
    some_array:
      - element1
      - element2

  development:
    <<: *defaults
    api_key: api key for dev

  test:
    <<: *defaults

  production:
    <<: *defaults

In the above example, you can define the key/value pair using strings, numbers, erb code, or arrays.  Notice that the "api_key" in the development
environment will override the "api_key" from defaults.


###Accessing the values in your Rails app

You simply call the Yetting class or the namespaced class and the key as a class method.  For namespaced yml files, Yettings will convert the filename in
/your_rails_app/config/yettings/ to a class name and append Yetting.  So if you have main.yml, then it will use MainYetting as the class name.
Then you can call the key that you put in the YAML as a class method.  Here are 2 examples:

  #/your_rails_app/config/yetting.yml in production
  Yetting.some_number #=> 999
  Yetting.api_key #=> "asdf12345lkj"

  #/your_rails_app/config/yettings/main.yml
  MainYetting.some_number #=> 999
  MainYetting.some_array #=> ["element1","element2"]


###Default settings
The above YAML content explicitly specifies settings for each environment using
YAML splats. In case you'd rather not write all those out, settings in the
'defaults' section will be used to populate each environment. So, the above file
could be written as

  defaults:
    api_key: asdf12345lkj
    some_number: 999
    an_erb_yetting: <%= "erb stuff works" %>
    some_array:
      - element1
      - element2

  development:
    api_key: api key for dev


## Encryption

You may be tempted to store sensitive information in your settings
files. For example, you may have places in your app where you use secret API
keys, passwords or other credentials that are a liability to keep in revision
control.

With version 0.2.0, Yettings supports encrypted values. To use this feature,
you'll need to generate a public/private keypair:

  rake yettings:gen_keys

Now you'll find the following files and directories in your project:

  config/yettings/.private_key
  config/yettings/.public_key
  config/yettings/.private/

You'll also automatically have the private key and private directory added to
the .gitignore file to avoid checking these into git. Now create a file in the
.private directory, let's call it secret.yml, and put something in there you
don't ever want anyone else to know about:

  # config/yettings/.private/secret.yml
  defaults:
    guilty_pleasure: singing into hairbrush

Whenever you run rails, you'll see a warning like this:

  $ ./bin/rails c
  WARNING: overwriting config/yettings/secret.yml.pub with contents of config/yettings/.private/secret.yml

Take a look at the secret.yml.pub file in that location and you'll see the contents are now encrypted:

  # config/yettings/secret.yml.pub
  ---
  defaults:
    guilty_pleasure: !binary |-
      YSgVHF+rhhBSRRaHIyOZwkd99ovrTvnfvsEdXjUXmbm2RdZTkBLzP+Ha275r
      gAwfY2P7AtkluGQmEpmr6f1C9XLI6hs3AHpkIE4OSJmOQAD2AU8lmw6oOg1j
      SJBX7F+v1i8WS+rhxF3y5uNtAh+Fv4w+N/d9w6iDed0wywLq1e3jXjbQv8KL
      rCf9FRpW2WTUYa+tntalaAQkNcp2Es3bWODfkZYOnsMm2POi5mtaCQR0/O8E
      1k1sToOqvt/vL1g24NeSTGXLndqo1pRkdhREkj7TiY6fFj3CXQtk+4JTJGGs
      bex7be+v9eEk5rJc7gu6uq1F9ymuWx+LUNHczppw4g==

Check this into git, then edit your private file again:

  # config/yettings/.private/secret.yml
  defaults:
    guilty_pleasure: singing into hairbrush
    specifically: '"Only in My Dreams" by Debbie Gibson'

Next time you run rails, your public file will be appended to, and you'll see
which key was updated when you commit to git again. This will help you if you
ever need to roll back your credentials.

  diff --git a/test_app/config/yettings/secret.yml.pub b/test_app/config/yettings/
  index 3c0e462..8d9555d 100644
  --- a/test_app/config/yettings/secret.yml.pub
  +++ b/test_app/config/yettings/secret.yml.pub
  @@ -7,3 +7,10 @@ defaults:
       rCf9FRpW2WTUYa+tntalaAQkNcp2Es3bWODfkZYOnsMm2POi5mtaCQR0/O8E
       1k1sToOqvt/vL1g24NeSTGXLndqo1pRkdhREkj7TiY6fFj3CXQtk+4JTJGGs
       bex7be+v9eEk5rJc7gu6uq1F9ymuWx+LUNHczppw4g==
  +  specifically: !binary |-
  +    A5M0/A3AbzkJaIXP3Ehtx0jPQtq2p8Y4SOqWN6OobkStjwSB6t9oHPDxA/jB
  +    mnzkyH6Hwsq0MMQjvJrRoDDNU7lTPnVSxGkwkHBD37I09X9JEim0qTC4M1Q3
  +    /VQEHtdEF8NfG9ZJs1b3iQNzu1CA2KNzUywmVpMJuwDNx4mSGdqpE37EeWMZ
  +    iuY/F+nfi6pJYktlmuis2uy8IDrAdEQ7k0x2i3dGs9KotiNAmCkRvq5jwH9a
  +    FXf30fXLX2cjWHQd3Ru3XurSOiN4LoYvAQBdgLyfX2ipapY8W+vcP8RmDBQR
  +    vu9miVub5T1xndclETuL97JTO6Yg8PU98Pv42289GQ==


## Contributing to yettings

* Check out the latest master to make sure the feature hasn't been implemented or the bug hasn't been fixed yet
* Check out the issue tracker to make sure someone already hasn't requested it and/or contributed it
* Fork the project
* Start a feature/bugfix branch
* Commit and push until you are happy with your contribution
* Make sure to add tests for it. I will not even look at patches without a test included.
* Please try not to mess with the Rakefile, version, or history. If you want to have your own version, or is otherwise necessary, that is fine, but please isolate to its own commit so I can cherry-pick around it.

## Copyright

Copyright (c) 2011 mc-2

