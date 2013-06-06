# collectd [![Build Status](https://secure.travis-ci.org/hectcastro/chef-collectd.png?branch=master)](http://travis-ci.org/hectcastro/chef-collectd)

## Description

Installs and configures collectd.  Much of the work in this cookbook reflects
work done by [coderanger](https://github.com/coderanger/chef-collectd)
and [realityforge](https://github.com/realityforge/chef-collectd).

## Requirements

### Platforms

* Amazon 2012.09
* RedHat 6.3 (Santiago)
* Ubuntu 12.04 (Precise)

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
* `node["collectd"]["graphite_role"]` – Role assigned to Graphite server for search.
* `node["collectd"]["graphite_ipaddress"]` – IP address to Graphite server if you're
  trying to target one that isn't searchable.

* `node["collectd"]["packages"]` – List of collectd packages.

## Recipes

* `recipe[collectd]` will install collectd from source.
* `recipe[collectd::attribute_driven]` will install collectd via node attributes.
* `recipe[collectd::packages]` will install collectd (and other plugins) from
  packages.
* `recipe[collectd::recompile]` will attempt to recompile collectd.

## Usage

In order to configure collectd via attributes, setup your roles like the following:

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
