#

## Checklist

* [ ] Terraform user setup with admin access **remember to remove later**
* [ ] Credentials temporarily placed in `.aws` folder. Delete on course completion.


## Section 1 Basic Operations

* terraform refresh will update for current state
* terraform plan attempts to make current state match desired state
    * If possible those changes will occur with already existing instances
    * If not possible terraform will destroy and create new instances
    that match the desired state.
* terraform state must be maintained to preserve
current state of the deployment


## Section 2 Basic Features


* Terraform Output
    * All arguments are attributes, and some things that aren't arguments are attributes
    * All attributes can become outputs
    * Attributes can be re-used within a file like a variable (example is an ip address)
    * To get the value of an output in the terraform.tfstate file run
        `terraform output <variable>`

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


Splat Expressions
    * Splat expressions are essentially regular expressions that work a lot like unix expressions
    * Example: `aws_iam_user.lb[*].arn` which matches all iam users starting with lb

GraphViz Support
    * Terraform represents rendering its internal DAG as a graph viz graph

Terraform Settings
    * `required_version` set a minimum version of terraform
    * `required_providers` list of required hashicorp providers


## Section 3 Providers

Provisionsers:
    * Need to configure machines beyond an install
    * Provisioners are the mechanism for triggering that
    * `local-exec` provisioners execute on our machine
        * Running Ansible, Puppet, Chef, etc. from your deployment machine
    * `remote-exec` provisioners
        * Invoke on the remote resource
    * List of types of provisioners available:
        * Chef
        * Salt
        * etc.

Creation vs. Destroy Time Provisioners
    * Creation only run during initial resource standup only
        * If it fails a resource is marked as "tainted" and the next apply will destroy the resource and recreate it.
    * Destroy only when a resource is deleted by terraform
    * Default type of a provisioner is creation
    * Specify destroy by adding `when = destroy` to the provisioner declaration.

Failure Behavior
    * By default a failure in a provisioner fails `terraform apply`
    * The `on_failure` setting can be used to change the default behavior
        * `continue` - ignore error and proceed
        * `fail` - raise an error and stop apply (default)