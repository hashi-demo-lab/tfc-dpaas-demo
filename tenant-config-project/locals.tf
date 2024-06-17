#read each yaml file in ./config/*.yaml
locals {
  config_file = flatten([for tenant in fileset(path.module, "config/*.yaml") : yamldecode(file(tenant))])
  tenant      = { for bu in local.config_file : bu.bu => bu }

  bu_project_list = flatten([
    for bu_key, bu_value in local.tenant : [
      for project_key, project_value in bu_value.projects : { "${bu_key}_${project_key}" : {
        bu      = bu_key
        project = project_key
        value   = project_value
        }
      }
    ]
  ])

  # convert list of bu_project_list to map
  bu_projects_access = { for bu_project in local.bu_project_list : keys(bu_project)[0] => values(bu_project)[0] }




  #read-outputs = { for key, value in local.bu_projects_access : key => value if length(value.value["read-outputs"]) > 0}

  #readoutputs_map = { for key in local.read-outputs : key => local.read-outputs[key].team_project_access.keys }

}

