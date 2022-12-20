# wordpress_terraform
<h2>Functional</h2>

Wordpress site located in a docker container created using ECS.


<h2>Running the project</h2>

If you want to run wordpress, you need:

•	Install Terraform to your local device

•	Download this project

•	You need add credentials to  
~/.aws/credentials file like

<code>
[myprofile]<br>
aws_access_key_id     = anaccesskey<br>
aws_secret_access_key = asecretkey<br>
</code></br>

•	Write to the terminal

<code>
$ terraform init

$ terraform apply
</code>

<h2>Authors</h2>

•	Danylo Kondiuk
