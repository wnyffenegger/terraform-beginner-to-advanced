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

# Section 4 Modules & Workspaces

Modules are your composable components of a deployment.
    
* A module specifies a resource to be created and can be re-used within multiple scenarios
* Modules are imported using their relative path ex. `../../modules/ec2`
* Modules support all of the functionality of normal terraform including variables
* Variables often contain defaults
* Overriding defaults example:
    ```
    module "ec2module" {
        source = "../../modules/ec2"
        instance_type = "t2.large"
    }
    ```

Terraform Registry
* Community maintained resource containing modules written by the community
* Verified modules are restricted to a small number of trusted HashiCorp partners.
Any verified module should be trusted.
* Documented in the same way that resources are
* Verified modules can be referenced by name to be retrieved during `terraform init`
* Downloaded modules are stored in `.terraform/modules`. The full module source is downloaded.

Terraform Workspace
* Scope that modules, vars, etc. are valid for
* Use multiple workspaces with different sets of environment variables
    * Staging -> t2.micro for dev machines
    * Production -> m4.large
* You can switch workspaces on the command line `terraform workspace help` for list of commands

Workspace Implementation
* `terraform show` list of workspaces
* `terraform workspace new <env>` creates new workspace
* Use `lookup` function with maps in code to change variables based on environment
* State is saved in a directory `terraform.tfstate.d` for all other workspaces besides `default`

# Section 5 Remote State Management

The one weakness of Terraform is the tfstate. When multiple people need to keep
tfstate in sync there needs to be a centralized management source for both the
code and the tfstate.

* tfstate saves secrets in cleartext
* tfstate must not be committed to git

Terraform Gitignore
* Check gitignore repository on GitHub
* There is a list of files to ignore for Terraform
* Not complete but a good start

## Modules can pull from git
```
module "vpc" {
    source = "git:https://github.com/acme/acme.git"
}
```

* You can pull via a variety of methods: https://www.terraform.io/docs/language/modules/sources.html
    * LocalPaths
    * Terraform Registry
    * GitHub, Bitbucket, S3, etc.
* You can check out from git several different ways
    * Via https
    * Via ssh
    * You can checkout specific branches as well


## Remote Back End

* Allows you to store tfstate in a remote backend separate from a central repository
* The tfstate never persists locally, it has to be pushed or pulled from that remote backend

* Supported backend types:
    * Standard: state storage and locking
    * Enhanced: standard + remote management

* Available backends: https://www.terraform.io/docs/language/settings/backends


### Implementing S3 Backend

* Create S3 Bucket
* Specify as part of Terraform configuration
* No local state file should be created

### Remote State File Locking

* When multiple people are working on the same infra you need terraform locking
* **Not all backend providers support locking**
* S3 does not support locking by default
* Need to add `dynamodb_table` to backend specification
* Locking creates row in dynamodb that is deleted after actions are completed


## Terraform State Management

* If you ever need to manually modify the Terraform state use `terraform state`
* Docs: https://www.terraform.io/docs/cli/commands/state/index.html
* Allows you to list and modify existing state resources
* Backs up state file after every command

* `terraform state list` list remote state
* `terraform state pull` pull remote state
* `terraform state push` use to replace a corrupted state
* `rm` remove items from state, those items are not destroyed but no longer managed by Terraform
* `terraform state show` show attributes of a single resource


## Terraform Import

When a change is made manually in AWS you need some way to get it into IaC.

`terraform import` will pull configuration of a resource down to you but you 
still have to write out the configuration yourself.


# Section 6 - Security Primer

AWS CLI

* You can load credentials at runtime as environment arguments to keep
them out of source code.


Multiple Providers

* In Terraform you can alias providers and start resources in different accounts/regions
* Add an `alias` to your provider specification to have multiple configurations of
a single provider
* 