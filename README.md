# Intro to Terraform with ACI

Welcome to this introductory Hands-On session for Terraform with ACI.

### Table of Contents

[1. Getting Familiar with Terraform Commands and Files](https://github.com/DevNetWorkshop2/Lab01-Terraform#1-getting-familiar-with-terraform-commands-and-files)

[2. Configuration Structure and Variables](https://github.com/DevNetWorkshop2/Lab01-Terraform#2-configuration-structure-and-variables)

[3. Understanding Terraform State](https://github.com/DevNetWorkshop2/Lab01-Terraform#3-understanding-terraform-state)

[4. Terraform Cloud with GitHub](https://github.com/DevNetWorkshop2/Lab01-Terraform#4-terraform-cloud-with-github)


First things first:

:computer: Start by cloning the repo into your directory and navigating to the folder. 
![image](https://user-images.githubusercontent.com/66415321/144844244-b6719643-1479-48a9-a582-7a6b3fc65ceb.png)


### 1. Getting Familiar with Terraform Commands and Files
------
Ensure terraform is installed on your workstation by entering `terraform -v`

In a browser go to http://10.254.1.51 and log in using the Username and Password provided.

Select `Tenants` and verify that no tenant with your name exists. 

Take a look at our terraform file: main.tf (either type `cat main.tf` or open it in a text editor, for example `nano main.tf`).

Look at the structure, and what types of resources will be created. 

#### Starting Terraform

It's time to create our first set of resources using Terraform. 

First we need to Initialize Terraform - This will download the required Terraform Providers. In this case the aci terraform provider, which is maintained by Cisco, and validated. More providers can be found in the [Provider Registry](https://registry.terraform.io/browse/providers).

```
terraform init
```

#### Creating Infrastructure

Before we go ahead and create our resources we can do a dry run using the `plan` command. 

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
Enter a value: https://10.254.1.51/

var.apic_username
Enter a value: use the crecentials provided
```

You should see a list of resources that will be created. 

If everything looks good, we can apply the changes using the `apply` command. 

```
terraform apply 
```
You will need to approve the changes by typing `yes` when prompted. 


To go the ACI GUI (https://10.254.1.51/) to see tenant that has been created.

#### Destroying Infrastructure

One of the differentiators of Terraform, is that managed infastructure can be removed just as quickly as it was created. 

To destroy your tenant, enter the `destroy` command. 

```
terraform destroy --auto-approve
```
:warning: Make sure you enter the same details you did during the apply process. 

:warning: The `--auto-approve` flag removes the need to type yes to approve changes. 


### 2. Configuration Structure and Variables
------
Terraform Configuration does not have to be written in a single file. It is best practice to separate parts of a configuration to different files, which in turn makes it easier to track changes. 

#### Variables

Look at the variables.tf file. 

```
variable "apic_url" {
    #default = "http://10.254.1.51"
}
variable "password" {}
variable "username" {}
variable "tenant_name" {}
```

We can set defaults for variables that will be filled, unless we overwrite them. 

Uncomment the default for the apic_url variable by removing the # and Save.

The terraform.tfvars file holds values to our already defined variables. 

Open terraform.tfvars

```
#apic_url = "https://10.254.1.51/"
#username = "admin"
#aci_tenant = USERNAME HERE
```

Uncomment the other variables, entering your initial + name for the aci_tenant variable and Save.

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

#### Putting it all Together

Now you know the basics of what makes up a Terraform configuration, use the [documentation](https://registry.terraform.io/providers/CiscoDevNet/aci/latest/docs) to configure some more resources to go into the Tenant that has been provisioned. 

- A VRF
- A Bridge Domain
- An Application Profile
- An End Point Group

As a Reference, here is the map of how these resources are interlinked in ACI:

![image](https://user-images.githubusercontent.com/8341286/144427265-579f3499-e447-4e76-aadd-c30a7d6964ad.png)

To clean up your code, you can type `terraform fmt`.

![image](https://user-images.githubusercontent.com/8341286/144432157-09d0417d-b6ca-47b2-8807-65df1cc4d6bc.png)


### 3. Understanding Terraform State
------

Look into your folder. From the previous exercise, you will see a Terraform state file in the directory. `terraform.tfstate`.

This file stores the last known state of the infastructure, and is used to compare the new configuration to the old, to know which changes have to be made. 

Open up main.tf. 

```
resource "aci_tenant" "terraform_tenant" {
  name        = "${var.tenant_name}"   
  description = "Tenant created by TF"
}

resource "aci_vrf" "terraform_vrf" {
  tenant_dn = aci_tenant.terraform_tenant.id
  description = "VRF created by TF" <- CHANGE THIS
  name = "${var.tenant_name}_terraform_vrf"
}
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


### 4. Terraform Cloud with GitHub
------

Working on Terraform code locally is good to get started. But when working in an organisation, or team, the challenge of managing the state file, as well as the configuration quickly comes up. 

To do this, we will store our configuration in GitHub and connect this to Terraform Cloud (TFC) which will execute our workflow, and store our state file. 

If you haven't done so, go to your browser and create an account at http://app.terraform.io.

Login and accept your invite to the Organisation DevNetWorkshop2.

Then, log into GitHub and create a new repository under the [DevNetWorkshop2 Organisation](https://github.com/DevNetWorkshop2) and give it a unique name. 

![image](https://user-images.githubusercontent.com/8341286/144427808-abba9d5f-6c8b-4694-af7b-10ec79449bd6.png)

![image](https://user-images.githubusercontent.com/8341286/144427928-d093e6e4-2264-4494-a177-b2e283c27a36.png)

Clone this repo to a Different folder using the GUI or CLI. 

```
cd ..
git clone <GITHUB_URL>
```

Copy across main.tf and variables.tf into the new directory. 

> Note: To configure variables we will use Terraform Cloud. 

Now we have our configuration ready, we can push this to GitHub. 

```
:warning: execute this from the new folder

git add .

git commit -m "initial configuration"

git push
```

Go to Terraform Cloud 

In Terraform Cloud, our configurations are organised in Workspaces. A Workspace respresents a collection of infrastructure arranged similarly to a working directory when working with the terraform cli. 

Create a new Workspace and select `Version Control Workflow`

![image](https://user-images.githubusercontent.com/8341286/144428403-69bd8683-9ddd-4b52-af88-5f4f4f461c5f.png)

![image](https://user-images.githubusercontent.com/8341286/144428520-07ed76d0-eae5-47c2-9c93-d78fedcfcf88.png)

Select GitHub...

![image](https://user-images.githubusercontent.com/8341286/144428660-13037bad-1aa0-4405-af41-0d5fc4b3490b.png)

...and select your Repository. 

On the last page, select "Create Workspace"

Go to Settings > General and select Execution Mode: Agent

![image](https://user-images.githubusercontent.com/8341286/144428826-6d085ced-a021-46d3-9d91-f09dffab8d7a.png)

> This Agent allows us to use the simplicity of Terraform Cloud, while providing a secure connection into our datacenter, to provision our infrastructure.

We now have the basics set up, however we have no variables configured yet. 

To to the Variables tab and Enter variables with names as per variables.tf

![image](https://user-images.githubusercontent.com/8341286/145015483-37557d43-7170-4cbc-856a-eccd6a5d1053.png)

```
apic_url: https://10.254.1.51/
password: use the one provided :warning: Check the Sensitive box to make this write-only
username: use the one provided
tenant_name: <YOUR_NAME>
```

Now click on the `Runs` tab, and select `Actions > Start new Plan`. This is the GUI equivalent of `terraform plan`. 

![image](https://user-images.githubusercontent.com/8341286/144430416-8e06d210-e8f2-492b-b38d-ace45364faaa.png)

When the plan is completed you will see the option to Confirm and Apply. 

Once applied, go th the APIC GUI to see the changes. 

Now every time you make a change to your code, and push it to GitHub, a new run will start. 

If you don't want to approve changes every time, you can set the Apply Method to "Auto Apply".

![image](https://user-images.githubusercontent.com/8341286/144430590-939f926c-96fb-45d1-8f97-6e2466c1346d.png)

#### Resources

To learn more, go to https://learn.hashicorp.com/terraform or join a hands-on workshop https://events.hashicorp.com/workshops
