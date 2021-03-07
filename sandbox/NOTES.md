#

## Checklist

* [ ] Terraform user setup with admin access **remember to remove later**
* [ ] Credentials temporarily placed in `.aws` folder. Delete on course completion.


## Section 1

* terraform refresh will update for current state
* terraform plan attempts to make current state match desired state
    * If possible those changes will occur with already existing instances
    * If not possible terraform will destroy and create new instances
    that match the desired state.
* terraform state must be maintained to preserve
current state of the deployment


## Section 2

* All arguments are attributes, and some things that aren't arguments are attributes
* All attributes can become outputs
* Attributes can be re-used within a file like a variable (example is an ip address)

* Variables are all prefixed with `var.var_name` when referenced in other locationster
* Variables can be passed in multiple ways
    * Vars file with defaults
    * Command line
    * Env variables
        * Must begin with TF_VAR_ ex. `TF_VAR_instancetype m5.large`
    * Vars files
        * Standard name is terraform.tfvars

* Variable datatypes
    * datatypes are enforced before plugins are checked
    * common types include string, list, map, number, bool
* **best practice to list types on all tf vars**

* Counting instances
    * `count` indicates number of resources to create
    * `count.index` is the index in the list of instances of a resource being created
    * `count.index` can be used for naming inside the resource

* Conditional expressions
    * if statement does occur in terraform but is contrived
    * `count = var.istest == false ? 1 : 0`
