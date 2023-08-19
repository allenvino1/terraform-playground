locals {

  #Init variables

  load_data = jsondecode(file("data_file.json"))

  load_fruits = jsondecode(file("data_file.json")).Fruits

  load_car = jsondecode(file("data_file.json")).Car

  load_workernodes = jsondecode(file("data_file.json")).WorkerNodes

  load_bq_iam_role_bindings = jsondecode(file("data_file.json")).bq_iam_role_bindings


  #Reverse the map key and value

  load_rev = {for key, value in local.load_data.Map1: value => key}

  #Create a list that filters the Worker type

  load_preemptible = [for i in local.load_workernodes: i if i.type == "Preemptible"]

  #Create a list from the key bq_iam_role_bindings
  #That each bq_iam_role_binding key has a map entry

                # member loop
  helper_load = flatten([for member_key, value in local.load_bq_iam_role_bindings: 
                  # dataset loop
                  [for dataset_key, roles_list in value: 
                    # role loop
                    [for role in roles_list: 
                      {
                        "member"  = member_key
                        "dataset" = dataset_key
                        "role"    = role
                      }
                    ] 
                  ]
                ])


  #Loop structure to generate with a map with the key of the name of workernodes. 
  #The whole structure will fail if there is a duplicate of name
  node_pools_loop =  { for v in local.load_workernodes : v.name =>
    {
      "type"       = v.type
      "Country"    = v.Country
    }
  }



  #Get only the unique node_pool_names. To used as a key in the map later on
  node_pool_names         = [for unp in toset(local.load_workernodes) : unp.name]

  #Create a set first to remove duplicate using toset 
  #convert to tolist as zipmap accepts only a list.
  #Much cleaner than nested loops
  node_pools              = zipmap(local.node_pool_names, tolist(toset(local.load_workernodes)))

}