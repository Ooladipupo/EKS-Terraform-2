

eval $(aws sts assume-role --role-arn "arn:aws:iam::457082365292:user/k8s-admin" --role-session-name "k8sAdminsession" | jq -r '.Credentials | "export AWS_ACCESS_KEY_ID=\(.AccessKeyId)\nexport AWS_SECRET_ACCESS_KEY=\(.SecretAccessKey)\nexport AWS_SESSION_TOKEN=\(.SessionToken)\n"')