## 2.1.1:

- Fixing init script

## 2.1.0:

- Add systemd support for RHEL 7.x.

## 2.0.0:

- Rename cookbook to `collectd-ng`.
- Add to [Chef Supermarket](https://supermarket.chef.io/cookbooks/collectd-ng).

## 1.3.0:

- Add support for setting `write_queue_limit_high`, `write_queue_limit_low`, and
  `collect_internal_stats`

## v1.2.1:

- Fix syntax error in `collectd_plugin` delete action.

## v1.2.0:

- Add support for `redis` plugin.

## v1.1.2:

- Fix syntax error in `packages` recipe.

## v1.1.1:

- Fix regression in ability to install and configure using `packages` recipe
  with `attribute_driven`.

## v1.1.0:

- Add support for ChefSpec.

## v1.0.0:

- Make use of `use_inline_resources` in resource providers. This change breaks
  backwards compatibility with versions of Chef prior to 11.

## v0.5.2:

* Add support for supplying `FQDNLookup` as an attribute.
* Ensure Python development libraries are when using the Python plugin on
  Debian.

## v0.5.1:

* Update metadata version.

## v0.5.0:

* Add support for collectd Python plugins.
* Add support for removing collectd plugins.

## v0.4.4:

* Add support for a plugin configuration directory different from the base directory.
* Add support for Ubuntu 14.04 (Trusty) to test suite.

## v0.4.3:

* Add support for `write_http` plugin.

## v0.4.2:

* Bump collectd version to `5.4.1`.

## v0.4.1:

* Fix permissions on `init.d` script.

## v0.4.0:

* Updated direct `yum` dependency to `yum-epel`.

## v0.3.1:

* Update Vagrant boxes in Test Kitchen suite.
* Fix issue with collectd installation and vagrant-cachier.

## v0.3.0:

* Bump collectd version to `5.4.0`.
* Update collectd download URL for Test Kitchen suite.
* Add alternative collectd download URLs to README.

## v0.2.2:

* Set `write_graphite` host attribute via `node.default` over `node.set`.

## v0.2.1:

* Fixed `write_graphite` plugin issues when overriding `Host` via attributes.

## v0.2.0:

* Fixed issues with Chef 11 attributes changes.

## v0.1.1:

* Fix FC043.

## v0.1.0:

* Added test-kitchen support.

## v0.0.8:

* Altered remote_file action to :create_if_missing.

## v0.0.7:

* Bump collectd version to 5.1.1.

## v0.0.6:

* Fix for RHEL5 package support for compilation.

## v0.0.5:

* Install libraries for plugins prior to compilation.

## v0.0.4:

* Fixes Foodcritic failures.
* Package installation support.
* RHEL init script support.
* Added a recompilation recipe.

## v0.0.3:

* Added build-essential as a dependency.

## v0.0.2:

* Scoped Graphite auto-discovery to Chef environment.

## v0.0.1:

* Initial release.
