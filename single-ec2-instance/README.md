# Single EC2 Instance

For just stupid simple testing.

-------------

Tested stopping an instance and terraforms response:

- `terraform get`
- `terraform plan`
- `terraform apply`
- `aws ec2 stop-instances --instance-ids i-0005d507c87e9e4e8`
- `aws ec2 describe-instances --instance-ids i-0005d507c87e9e4e8 | jq '.Reservations[0].Instances[0].State'`
- `terraform plan`

Terraform detects the resource is still there but does not worry about
its described altered state.

https://github.com/hashicorp/terraform/issues/1579
