terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "6.28.0"
    }

    random = {
      source = "hashicorp/random"
      version = "3.8.1"
    }
  }
}

provider "aws" {  # this is for the highlevel aws provider
  
    region = "eu-west-1" # here we are calling the variable region which we have defined above
}


locals {
  user_data=yamldecode(file("./users.yaml") ).users# fetch the data from this one file and then use that one data and then process that one data 
 #get the users data from the users.yaml file and then we can use that one data to create the iam users and then assign the policies to the users based on the data in the yaml file  

 user_role_pair=flatten([for user in local.user_data : # so this is for the users who have the multiple roles 

 [ for roles in user.Roles:
  {username=user.username, 
  role=roles  
  }]]) # this will give me the data which is in the users.yaml file and i can use this data to create the iam users and then assign the policies to the users based on the data in the yaml file

}



output "userdata" {
    value = local.user_data[*].username # this will give me the data which is in the users.yaml file and i can use this data to create the iam users and then assign the policies to the users based on the data in the yaml file   
  
}


output "role" {

    value = local.user_role_pair # this will give me the data which is in the users.yaml file and i can use this data to create the iam users and then assign the policies to the users based on the data in the yaml file   
  
}


#creating users all the users will be created based on the data in the users.yaml file and it will create the users based on the username in the yaml file so if there are 3 users in the yaml file then it will create 3 users in aws iam
resource "aws_iam_user" "users" {
    for_each=toset(local.user_data[*].username) # this will create the iam users based on the data in the users.yaml file and it will create the users based on the username in the yaml file so if there are 3 users in the yaml file then it will create 3 users in aws iam   
    name=each.value # this will take the username from the yaml file and create the iam user with that username
    
} 



#password creation for these users
resource "aws_iam_user_login_profile" "profile" {
  for_each=aws_iam_user.users # this will create the login profile for the iam users which we have created above and it will create the login profile based on the username in the yaml file so if there are 3 users in the yaml file then it will create 3 login profiles in aws iam
  user=each.value.name # this will take the username from the yaml file and create the login profile with that username
  password_length=16 # this will set the password length for the iam users which we have created above and it will set the password length to 16 characters
   lifecycle {
     ignore_changes = [
      password_length,
      password_reset_required,
      pgp_key,
    ]
  }

   }

#now attaching the policies to the users based on the data in the yaml file so if there are 3 users in the yaml file and each user has different policies then it will attach the policies to the users based on the data in the yaml file
# flaten function in terraform is used to convert the list of lists into a single list so that we can use that one data to create the iam users and then assign the policies to the users based on the data in the yaml file
resource "aws_iam_user_policy_attachment" "Policies" {

  for_each={for pair in local.user_role_pair : "${pair.username}-${pair.role}" => pair} # this will create the iam user policy attachment based on the data in the users.yaml file and it will create the iam user policy attachment based on the username and role in the yaml file so if there are 3 users in the yaml file then it will create 3 iam user policy attachments in aws iam   
  #Tirath-Ec2FullAccess=> {username=Tirath, role=Ec2FullAccess} this is the data which will be created in the local.user_role_pair and then it will use this data to create the iam user policy attachment based on the username and role in the yaml file so if there are 3 users in the yaml file then it will create 3 iam user policy attachments in aws iam
  

  user=aws_iam_user.users[each.value.username].name # this will take the username from the yaml file and create the iam user policy attachment with that username
  policy_arn="arn:aws:iam::aws:policy/${each.value.role}" # this will take the role from the yaml file and create the iam user policy attachment with that role
  
}