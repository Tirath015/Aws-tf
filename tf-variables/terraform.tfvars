instance_type="t2.micro"
ec2-config = {
  volume_size = 20
  volume_type = "gp3"
}

additional_tags = {
  "DEPT" = "QA"
  "Project" = "TerraformLearning"
}

# the values which i give here will override the default values given in variable block in variables.tf file    