# Intro to Terraform with ACI

Welcome to this introductory Hands-On session for Terraform with ACI.

### Table of Contents

[Getting Familiar with Terraform Commands and Files](https://github.com/cedricfeist/tf-aci-intro-hands-on#intro-to-terraform-cloud)

[Config Structure and Variables](https://github.com/cedricfeist/tf-aci-intro-hands-on#intro-to-terraform-cloud)

[Understanding Terraform State](https://github.com/cedricfeist/tf-aci-intro-hands-on#understanding-terraform-state)

[Intro to Terraform Cloud](https://github.com/cedricfeist/tf-aci-intro-hands-on#intro-to-terraform-cloud)

[Terraform Cloud with GitHub](https://github.com/cedricfeist/tf-aci-intro-hands-on#terraform-cloud-with-github)


First things first:

Start by cloning the repo into your directory and navigating to the folder.

```
git clone https://github.com/cedricfeist/tf-aci-intro-hands-on

cd tf-aci-intro-hands-on
```


### Getting Familiar with Terraform Commands and Files
------
Navigate to the first folder.

```
cd 1-tf-intro-cli
```

Ensure terraform is installed on your workstation by entering `terraform -v`

In a browser go to http://10.254.1.21 and log in using the Username and Password provided.

Select `Tenants` and verify that no tenant with your name exists. 

Take a look at our terraform file: main.tf (either type `cat main.tf` or open it in a text editor, for example `nano main.tf`).

Look at the structure, and what types of resources will be created. 

###### Starting Terraform

It's time to create our first set of resources using Terraform. 

First we need to Initialize Terraform - This will download the required Terraform Providers. In this case the aci terraform provider, which is maintained by Cisco, and validated. More providers can be found in the [Provider Registry](https://registry.terraform.io/browse/providers).

```
terraform init
```

Before we go ahead and create our resources we can do a dry run using the `plan` command. 

###### Plan

```
terraform plan
```

You will need to provide some inputs for this to run. 

```
var.aci_tenant
Enter a value: <enter your initial + name here>

var.apic_password
Enter a value: use the crecentials provided

var.apic_url
Enter a value: https://10.254.1.21/

var.apic_username
Enter a value: use the crecentials provided
```

You should see a list of resources that will be created. 

###### Apply

If everything looks good, we can apply the changes using the `apply` command. 

```
terraform apply 
```
You will need to approve the changes by typing `yes` when prompted. 


To go the ACI GUI (https://10.254.1.21/) to see tenant that has been created.

###### Destroying Infrastructure

One of the differentiators of Terraform, is that managed infastructure can be removed just as quickly as it was created. 

To destroy your tenant, enter the `destroy` command. 

```
terraform destroy --auto-approve
```
:warning: Make sure you enter the same details you did during the apply process. 

:warning: The `--auto-approve` flag removes the need to type yes to approve changes. 


### Config Structure and Variables
------
Terraform Configuration does not have to be written in a single file. It is best practice to separate parts of a configuration to different files, which in turn makes it easier to track changes. 

#### Variables

Look at the variables.tf file. 

```
nano variables.tf
```

We can set defaults for variables that will be filled, unless we overwrite them. 

Uncomment the default for the apic_url variable by removing the # and Save: `ctrl+x, enter, enter`

The terraform.tfvars file holds values to our already defined variables. 

Open terraform.tfvars

```
nano terraform.tfvars
```

Uncomment the other variables, entering your initial + name for the aci_tenant variable and Save: `ctrl+x, enter, enter`

We can now apply the same code again, however now we don't have to enter values for each variable again. This increases the usability of our code as we can exchange the variable name for our tenant, and reproduce the exact same tenant as many times as we want. 

```
terraform apply
```

More on Variables and how they can be used can be found in the [Documentation](https://www.terraform.io/docs/language/values/variables.html).

Terraform loads variables in the following order, with later sources taking precedence over earlier ones:

- Environment variables
- The terraform.tfvars file, if present.
- The terraform.tfvars.json file, if present.
- Any *.auto.tfvars or *.auto.tfvars.json files, processed in lexical order of their filenames.
- Any -var and -var-file options on the command line, in the order they are provided. (This includes variables set by a Terraform Cloud workspace.)

#### Outputs

Open the file outputs.tf and uncomment our output variable. 

```
terraform apply --auto-approve
```

We now get an output of an object which was created during our apply process. This can be helpful when some things such as IPs are dynamically assigned during creation. 

Do not destroy these changes. 


### Understanding Terraform State
------
Open up main.tf. 

```
nano main.tf
```

Change name of one of the resources in main.tf.

> :warning: make sure you change the name behind 'name = ' and not the reference of the resource itself. 

Save the changes and apply the changes. 

```
terraform apply
```

You will see that some resources might be deleted and recreated, while some resources will be modified. 

:warning: Note: ACI is immutable, so are many clouds, so certain changes may trigger an object to be deleted and recreated, instead of changed. 

```
terraform destroy --auto-approve
```


### Intro to Terraform Cloud
------
Go to the second directory. 

```
cd ../2-tfc-cli
```

First we will solve the problem of managing your state file when working in a team. 

To do this, we will upload our state file to Terraform Cloud (TFC). This ensures that our state file is centrally managed, so that we don't overwrite each others changes. 

Go to your browser and create an account at http://app.terraform.io

Login and accept your invite to the Organisation DevNetWorkshop2.

In Terraform Cloud, our configurations are organised in Workspaces. A Workspace respresents a collection of infrastructure arranged similarly to a working directory when working with the terraform cli. 

Go to Workspaces and select `+ New workspace` 

Select CLI-driven workflow

Name: <your_username>_cli

Select `Create worspace`

Go to Settings > General > Terraform Version: Your TF Version
> :warning: Your Terraform version can be found on the CLI using `terraform version`

Settings > General > Execution Mode: Local

Save Settings

> Back to Terminal

Open main.tf using `nano main.tf` and replace the workspace name with your initial + name and Save: `ctrl+x, enter, enter` 

Enter your name in the terraform.tfvars file `nano terraform.tfvars` and uncomment the line. 

We now need to link our local working directory with Terraform Cloud: 

```
terraform login
```

A broser window will open, you may have to log in again. 

Save the Token that will be created after giving it a name and paste in the terminal when prompted. 

```
terraform apply
```

Wait until the tenant has been provisioned, and go to your Workspace > States. You should see the state saved in TFC. 

```
terraform destroy
```


### Terraform Cloud with GitHub
------
Now our state file is hosted in the cloud, but we still have our configuration hosted locally, which is not ideal if multiple people will be working on it. Luckily, TFC has Version Control System integrations to simplify the connection with GitHub, GitLab, and others. 

First, log into GitHub and create a new repo under the DevNetWorkshop2 Organisation and give it a unique name. 

Clone this repo to a Different folder.

```
cd ../..
git clone <GITHUB_URL>
```

Copy across main.tf and variables.tf from 3-tfc-github

```
cp tf-aci-intro-hands-on/3-tfc-github/. .
```

> Note: no variables are configured yet, we will do this in Terraform Cloud. 

Now we have some configuration ready, we can push this to GitHub. 

```
git add .

git commit -m "initial configuration"

git push
```

Go to Terraform Cloud 

Create a new Workspace like before, but select `VCS Driven Workflow`

Select GitHub|GitHub and select your Repository. 

Go to Settings > General and select Execution Mode: Agent

> This Agent allows us to use the simplicity of Terraform Cloud, while providing a secure connection into our datacenter, to provision our infrastructure.

We now have the basics set up, however we have no variables configured yet. 

To to the Variables tab and Enter variables with names as per variables.tf
```
apic_url: https://10.254.1.21/
password: use the one provided
username: use the one provided
tenant_name: <YOUR_NAME>
```

Now click on the `Runs` tab, and select `Actions > Start new Plan`. This is the GUI equivalent of `terraform plan`. 

When the plan is completed you will see the option to Confirm and Apply. 

Once applied, go th the APIC GUI to see the changes. 

Now every time you make a change to your code, and push it to GitHub, a new run will start. 