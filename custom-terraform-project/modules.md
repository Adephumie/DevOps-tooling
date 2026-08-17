# Modules

Without modules, complex configurations become huge terraform files that become more difficult to manage. When
you need to make quick changes, you will have to scroll through 100s of lines of code to get simple things done.
This isn't so efficient.

Modules in terraform helps to organize and group configurations. What this means is that you can have a file config that is used for creating EC2. Everything needed to create an EC2 instance would be grouped together.

Modules encourage reusability because you can easily parameterize values that can be used across different environments. Modules are like functions in programming language. Input variables are like function arguments while output values are like function return values.

## Modules Creation

You can create your own modules for use, however, Terraform and other comapanies already have modules that have created and can be used by anyone.

To navigate to modules tab on Terraform Registry, you can google search Terraform modules. Then, on the page, look for the resource modules you want to use.

For example, the `terraform-aws-modules/vpc` module has documentation, found in the `Readme` tab, that can help you find code usage examples.

The `Resources` tab gives you an overview of the resources you can configure using the module. Once you provide the parameters, they will be created.

The parameters you can parse into the codes are defined in the `inputs` tab. The input and their definition are well documented in the tab.

While the outputs define values that can be returned to you after the creation of resources using the module.

The dependency tab lists the external modules that the module depends on. It also lists the providers used with the version.

Modules is where you break down your main.tf file holding all the codes into variables.tf, outputs.tf, etc.

When creating a module you should group at least three to four resources together for it to make any sense.


