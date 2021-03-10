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


* Local Values
    * Scoped to a single tform module
    * Referred to like vars `local.common_tags`

* Terraform Built In Functions
    * Standardized functions for common use cases
    * Only built in functions are supported, no user defined functions
    * List of functions https://www.terraform.io/docs/language/functions/index.html 
    * ** Use the `terraform console` to test out functions
    * Functions are organized by the type of entity they act on (String, Numeric, Collection, File)
    * `lookup` acts on a map so the documentation is found in the Collection group

* Terraform Datasources
    * Allow you to specify where to pull information from
    * Parameterize based on regions, os, etc. an allow values
    to be computed during terraform plan/apply rather than hard coded
    * Organizations can configure custom data sources to pull resources from

* Debugging Terraform
    * **TF_LOG** and **TF_LOG_PATH** set logging level and where to log.
    * Example: 
    ```bash
        export TF_LOG_PATH=/tmp/crash.log
        export TF_LOG=TRACE
    ```

* Terraform Format
    * Automatically format to Terraform standards
    * `terraform fmt` will auto format to correct indentation

* File load order
    * 

* Dynamic Blocks
    * Dynamic block allows creating a for loop for specifiying coimponents of resources
    * Instead of enumerating every value in a list individually use the dynamic block to iterate over the list implicitly
    * Requires the use of some form of list or map to help specify the structure and values in the loop
    * Example:
    ```
      dynamic "ingress" {
        # List to iterate over  
        for_each = var.sg_ports
        # Specify variable name for item in list
        iterator = port
        content {
            from_port   = port.value
            to_port     = port.value
            protocol    = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
      }
    ```

Tainting Resources
    * You can mark resources as tainted to force terraform to mark a resource as modified and schedule to be deleted on next plan/apply
    * Usage: `terraform taint <resource-to-delete>
    * Tainting a resource only marks in the terraform state file, changes are done on the next apply.
    * Tainting can effect dependencies of a resource as well but might not be automatically caught.