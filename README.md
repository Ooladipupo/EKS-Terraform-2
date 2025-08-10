### to swich user, 

pass in the aws account access and secret key as environmentla variable using export command
export AWS_ACCESS_KEY_ID="XXX"
export AWS_SECRET_ACCESS_KEY="XXX"


### to confirm you are login with the new user id, run
    $ aws sts get-caller-identity



#### use this script to assume a role (developer or admin role) to be reated

eval $(aws sts assume-role --role-arn arn:aws:iam::${AWSAccountId}:role/role-name --role-session-name awscli-session | jq -r '.Credentials | "export AWS_ACCESS_KEY_ID=\(.AccessKeyId) AWS_SECRET_ACCESS_KEY=\(.SecretAccessKey)\ AWS_SESSION_TOKEN=\(.SessionToken)\n"')