def collectd_option(option)
  if option.kind_of? String
    "\"#{option}\""
  else
    option
  end
end

def solaris_package_version_to_name(version)
  if version.kind_of? String
    version.gsub('.','')
  else
    version
  end
end
