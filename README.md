# Intro to Terraform with ACI

Welcome to this introductory Hands-On session for Terraform with ACI.

### Table of Contents

Getting Familiar with Terraform Commands and Files

Config Structure and Variables

Understanding Terraform State

Intro to Terraform Cloud

Terraform Cloud with GitHub


First things first:

Start by cloning the repo into your directory and navigating to the folder.

```
git clone https://github.com/cedricfeist/tf-aci-intro-hands-on

cd kubernetes-hands-on
```

### Getting Familiar with Terraform Commands and Files

Navigate to the first folder.

```
cd 1-tf-intro-cli
```

Ensure terraform is installed on your workstation by entering `terraform -v`

In a browser go to ACIURL and log in USER:PW

Select Tenants

Initialize Terraform - This will download the required Terraform Providers.

```
terraform init
```

Take a look at the file main.tf (either type `cat main.tf` or open it in a text editor, for example `nano main.tf`)

```
terraform plan
```

```

var.apic_password
Enter a value: use the crecentials provided

var.apic_url
Enter a value: https://10.254.1.21/

var.apic_username
Enter a value: use the crecentials provided
```

See what will be created


Apply 

```
terraform apply
```

To go GUI (https://10.254.1.21/) to see tenant.

Destroy

```
terraform destroy --auto-approve
```

:warning: Only add --auto-approve if you are sure about the action.

### Config Structure and Variables

Different .tf files bla

Look at variables.tf

Defaults

Edit terraform.tfvars

```
nano terraform.tfvars
```

Uncomment variables, enter name

Save ctrl+x, enter, enter

```
terraform apply
```

More on Variables here: https://www.terraform.io/docs/language/values/variables.html

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

Environment variables
The terraform.tfvars file, if present.
The terraform.tfvars.json file, if present.
Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)


### Understanding Terraform State



### Intro to Terraform Cloud

### Terraform Cloud with GitHub
