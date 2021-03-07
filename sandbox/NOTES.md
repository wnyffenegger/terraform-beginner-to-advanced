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
* 