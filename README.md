# Sluggerator

Sluggerator™ helps remove build artifacts from your Heroku slug before it's compressed.

### Why?

Heroku's `.slugignore` file is useful for pruning out files from **YOUR** git repo from the
generated slug. But unfortunately, it doesn't do anything for file generated *during* the
build process.

For example, the `wkhtmltopdf-binary` ruby gem installs almost a dozen 17MB binary files, 
most of which are unnecessary on any given platform. Heroku's `.slugignore` can't handle 
this situation because the gem is installed during the build process, not in git ahead of time.

# Dependencies / Language Support

Sluggerator is language- and framework-independent and is written in pure bash using very basic utilities.

# Compatibility

Sluggerator is known to work on the `heroku-18`, `heroku-20` and `heroku-22` stacks on Heroku.

# Basic Usage

    heroku buildpacks:add https://github.com/bisrael/sluggerator.git

## Note!

This should probably be the *last* buildpack in your list.

The above command will add it as such, but if adding other buildpacks later,
make sure to use the `-i` flag to put your other buildpacks *before* this one.

# Modes of Operation

There are two primary modes that Sluggerator operates in:

1. `Sluggerator` file mode
2. `.slugignore` file mode

Sluggerator can also help you report on various file sizes with a `Sluggerator.report-only` file

## `Sluggerator` file mode

Add a `Sluggerator` file to the root of your app's repo.

The format is similar to other `.ignore`-type files, 
any globbing supported by Ubuntu's `ls` command on your build container is supported.

### Example `Sluggerator` file:

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
vendor/bundle/ruby/*/gems/wkhtmltopdf-binary-*/bin/wkhtmltopdf_archlinux*
vendor/bundle/ruby/*/gems/wkhtmltopdf-binary-*/bin/wkhtmltopdf_centos*
vendor/bundle/ruby/*/gems/wkhtmltopdf-binary-*/bin/wkhtmltopdf_debian*
vendor/bundle/ruby/*/gems/wkhtmltopdf-binary-*/bin/wkhtmltopdf_macos*
vendor/bundle/ruby/*/gems/wkhtmltopdf-binary-*/bin/wkhtmltopdf_ubuntu*i386*
vendor/bundle/ruby/*/gems/wkhtmltopdf-binary-*/bin/wkhtmltopdf_ubuntu_16*
```

## `.slugignore` file mode

This mode operates basically exactly as above, but instead reads the heroku-supported `.slugignore` file.

The same rules apply here, but allow you to put all of your ignore 

# Other Features

## `Sluggerator.report-only` file 

After Sluggerator removes files from your heroku slug, you can optionally have it report on file-sizing in various directories.

You can do this by creating a `Sluggerator.report-only` file in your app root.

```ignorelang
# This causes an output of large gemfiles at the end of the build:
vendor/bundle/ruby/*/gems/*
vendor/bundle/ruby/*/gems/**/*
```

Syntax supported here is any file globbing that the `du` utility on your Ubuntu/Heroku stack supports.

Currently, Sluggerator only reports files >= 10 Megabytes

# Development

See: https://devcenter.heroku.com/articles/buildpack-api
