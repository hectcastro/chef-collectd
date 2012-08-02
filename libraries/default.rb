def collectd_option(option)
  if option.kind_of? String
    "\"#{option}\""
  else
    option
  end
end
