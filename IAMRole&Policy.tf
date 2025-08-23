
#we want to create a role to be used by our kUBERNETES developers and Adminstrators. 
#Please note that this role is different from the cluster role to be used by our kubernetes cluster and the node group role




#the below is an AWS IAM specific role. We are yet to do anything with EKS RBAC at this point, we would give it also an inline policy
resource "aws_iam_role" "external-developer" {
  name = "external-developer"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = var.user_for_dev_role
        }
      },
    ]
  })
}

#note that the use of terraform inline_policy has been deprecated. hence, we need to create our policy or use any of the customer policies on AWS
#then we use the aws_iam_role_policy_attachment to attach the policy to the role. as you would see below. 
resource "aws_iam_role_policy_attachment" "devopsshack_cluster_role_policy_for_developer" {
  role       = aws_iam_role.external-developer.name
  policy_arn = "arn:aws:iam::457082365292:policy/DescribeCluster"
}



#lets create a similar role for the kubernetes administrator and attached the same 
resource "aws_iam_role" "external-admin" {
  name = "external-admin"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Action = "sts:AssumeRole"
        Effect = "Allow"
        Sid    = ""
        Principal = {
          AWS = var.user_for_admin_role
        }
      },
    ]
  })
}

#note that the use of terraform inline_policy has been deprecated. hence, we need to create our policy or use any of the customer policies on AWS
#then we use the aws_iam_role_policy_attachment to attach the policy to the role. as you would see below. 
resource "aws_iam_role_policy_attachment" "devopsshack_cluster_role_policy_for_admin" {
  role       = aws_iam_role.external-admin.name
  policy_arn = "arn:aws:iam::457082365292:policy/DescribeCluster"
}


#Next is to map the above IAM roles to our kubernetes. prior to know, the mapping is done using aws_auth configmap resources, 
#now deprecated and replaced with eks api resouce called aws_wks_access_entry


resource "aws_eks_access_entry" "developer" {
  cluster_name      = aws_eks_cluster.devopsshack.name
  principal_arn     = aws_iam_role.external-developer.arn
  user_name         = "developer"
}

resource "aws_eks_access_entry" "admin" {
  cluster_name      = aws_eks_cluster.devopsshack.name
  principal_arn     = aws_iam_role.external-admin.arn
  user_name         = "admin"
}

resource "aws_eks_access_entry" "github_oidc" {
  cluster_name = aws_eks_cluster.devopsshack.name
  principal_arn = "arn:aws:iam::457082365292:role/Github-action"
  kubernetes_groups = ["system:masters"]
  type = "STANDARD"
}
