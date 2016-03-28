# Taint with count

Inside `main.tf` a vpc and four security groups are created.  The SGs are created using count.

To taint a resource with count using this example, simply run:

```
terraform taint aws_security_group.count-example.3
The resource aws_security_group.count-example.3 in the module root has been marked as tainted!
```
