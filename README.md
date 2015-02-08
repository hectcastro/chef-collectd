# collectd [![Build Status](https://secure.travis-ci.org/hectcastro/chef-collectd.png?branch=master)](http://travis-ci.org/hectcastro/chef-collectd)

## Description

Installs and configures collectd.  Much of the work in this cookbook reflects
work done by [coderanger](https://github.com/coderanger/chef-collectd) and
[realityforge](https://github.com/realityforge/chef-collectd).

## Requirements

### Platforms

* Amazon 2012.09
* CentOS 6.5
* Ubuntu 12.04

### Cookbooks

* build-essential
* yum

## Attributes

* `node["collectd"]["version"]` - Version of collectd to install.
* `node["collectd"]["dir"]` - Base directory for collectd.
* `node["collectd"]["url"]` - URL to the collectd archive.
* `node["collectd"]["checksum"]` - Checksum for the collectd archive.
* `node["collectd"]["interval"]` - Number of seconds to wait between data reads.
* `node["collectd"]["read_threads"]` - Number of threads performing data reads.
* `node["collectd"]["name"]` - Name of the node reporting statstics.
* `node["collectd"]["plugins"]` - Mash of plugins for installation.
* `node["collectd"]["python_plugins"]` - Mash of Python plugins for installation.
* `node["collectd"]["plugins_conf_dir"]` - Directory for collectd plugins configuration files.
* `node["collectd"]["graphite_role"]` – Role assigned to Graphite server for
  search.
* `node["collectd"]["graphite_ipaddress"]` – IP address to Graphite server if
  you're trying to target one that isn't searchable.
* `node["collectd"]["packages"]` – List of collectd packages.

## Recipes

* `recipe[collectd]` will install collectd from source.
* `recipe[collectd::attribute_driven]` will install collectd via node attributes.
* `recipe[collectd::packages]` will install collectd (and other plugins) from
  packages.
* `recipe[collectd::recompile]` will attempt to recompile collectd.

## Usage

By default this cookbook will attempt to download collectd from collectd.org.
If your HTTP request includes Chef as the user agent, collectd.org returns an
HTTP response with a message asking you to please stop using their downloads
via Chef. It is **highly recommended** that you override
`node["collectd"]["url"]` with your own download location for collectd.

A list of alternative download locations for collectd:

* [https://s3.amazonaws.com/collectd-5.4.1/collectd-5.4.1.tar.gz](https://s3.amazonaws.com/collectd-5.4.1/collectd-5.4.1.tar.gz) (@ahochman)

In order to configure collectd via attributes, setup your roles like:

```ruby
default_attributes(
  "collectd" => {
    "plugins" => {
      "syslog" => {
        "config" => { "LogLevel" => "Info" }
      },
      "disk"      => { },
      "swap"      => { },
      "memory"    => { },
      "cpu"       => { },
      "interface" => {
        "config" => { "Interface" => "lo", "IgnoreSelected" => true }
      },
      "df"        => {
        "config" => {
          "ReportReserved" => false,
          "FSType" => [ "proc", "sysfs", "fusectl", "debugfs", "devtmpfs", "devpts", "tmpfs" ],
          "IgnoreSelected" => true
        }
      },
      "write_graphite" => {
        "config" => {
          "Prefix" => "servers."
        }
      }
    }
  }
)
```
