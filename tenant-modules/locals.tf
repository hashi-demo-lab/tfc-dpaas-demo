locals {
  #nested map, get key of pipeline_vars
  pipeline_vars = { for module in local.modules_config.modules : module.module_name => module.pipeline_vars }

  variables_list = flatten([
    for module_key, attributes in local.pipeline_vars : [
      for attr_key, value in attributes : { "${module_key}_${attr_key}" : {
        module    = module_key
        variable = attr_key
        value     = value
      } }
  ]])

  var_map = merge([for item in local.variables_list : item]...)

  labels = { for module in local.modules_config.modules : module.module_name => module.labels }
  #map with key per "module and label"
  labels_list = flatten([ for module_key, attributes in local.labels : [
    for attr_key, value in attributes : { "${module_key}_${attr_key}" : {
      repo    = module_key
      label = attr_key
      color     = value
    } }
  ]])

  labels_map = merge([for item in local.labels_list : item]...)
  
}