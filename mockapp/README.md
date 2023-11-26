1. Configure
Use the name of your application
```
variable "tag" {
  description = "Prefix for the tags"
  default     = "<your application name>"
}
```

2. Deploy
```
$ terraform init
$ terraform apply
```