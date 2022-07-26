# sluggerator
Helps remove build artifacts from your Heroku slug

# Usage

    heroku buildpacks:add https://github.com/bisrael/sluggerator.git

Note! This should probably be the *last* buildpack in your list.
The above command will add it as such, but if adding other buildpacks later,
make sure to use the `-i` flag to put your other buildpacks *before* this one.

Add a `Sluggerator` file to the root of your app's repo.

The format is similar to other `.ignore`-type files, 
any globbing supported by bash's `ls` command is supported.

## Example `Sluggerator` file:

This removes a bunch of extraneous binaries from the `wkhtmltopdf-binary` gem
that are not needed on the Heroku runtime:

```ignorelang
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_archlinux_amd64.gz
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_centos_6_amd64.gz
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_centos_6_i386.gz
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_centos_7_amd64.gz
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_centos_7_i386.gz
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_centos_8_amd64.gz
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_debian_10_amd64.gz
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_debian_10_i386.gz
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_debian_9_amd64.gz
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_debian_9_i386.gz
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_macos_cocoa.gz
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_ubuntu_16.04_amd64.gz
vendor/bundle/ruby/2.6.0/gems/wkhtmltopdf-binary-0.12.6.5/bin/wkhtmltopdf_ubuntu_16.04_i386.gz
```

You can version and future-proof this like so:

```ignorelang
vendor/bundle/ruby/*/gems/wkhtmltopdf-binary-*/bin/wkhtmltopdf_{archlinux,centos,debian,macos}
vendor/bundle/ruby/*/gems/wkhtmltopdf-binary-*/bin/wkhtmltopdf_ubuntu_16*
```

As you update your heroku stack to newer ubuntu versions, you could replace

```ignorelang
vendor/bundle/ruby/*/gems/wkhtmltopdf-binary-*/bin/wkhtmltopdf_ubuntu_16*
```

with

```ignorelang
vendor/bundle/ruby/*/gems/wkhtmltopdf-binary-*/bin/wkhtmltopdf_ubuntu_{16,18}*
```

# Development

See: https://devcenter.heroku.com/articles/buildpack-api
