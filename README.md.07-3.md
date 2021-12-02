#devops-netology
### 07-terraform-03-basic
# Домашнее задание к занятию "7.3. Основы и принцип работы Терраформ"

## Задача 1. Создадим бэкэнд в S3 (необязательно, но крайне желательно).

Если в рамках предыдущего задания у вас уже есть аккаунт AWS, то давайте продолжим знакомство со взаимодействием
терраформа и aws. 

1. Создайте s3 бакет, iam роль и пользователя от которого будет работать терраформ. Можно создать отдельного пользователя,
а можно использовать созданного в рамках предыдущего задания, просто добавьте ему необходимы права, как описано 
[здесь](https://www.terraform.io/docs/backends/types/s3.html).
1. Зарегистрируйте бэкэнд в терраформ проекте как описано по ссылке выше. 

## Задача 2. Инициализируем проект и создаем воркспейсы. 

1. Выполните `terraform init`:
    * если был создан бэкэнд в S3, то терраформ создат файл стейтов в S3 и запись в таблице 
dynamodb.
    * иначе будет создан локальный файл со стейтами.  
1. Создайте два воркспейса `stage` и `prod`.
1. В уже созданный `aws_instance` добавьте зависимость типа инстанса от вокспейса, что бы в разных ворскспейсах 
использовались разные `instance_type`.
1. Добавим `count`. Для `stage` должен создаться один экземпляр `ec2`, а для `prod` два. 
1. Создайте рядом еще один `aws_instance`, но теперь определите их количество при помощи `for_each`, а не `count`.
1. Что бы при изменении типа инстанса не возникло ситуации, когда не будет ни одного инстанса добавьте параметр
жизненного цикла `create_before_destroy = true` в один из рессурсов `aws_instance`.
1. При желании поэкспериментируйте с другими параметрами и рессурсами.

В виде результата работы пришлите:
* Вывод команды `terraform workspace list`.
* Вывод команды `terraform plan` для воркспейса `prod`.  

**Ответ:**
После выполнения получил на aws бакеты как на [скрине](https://drive.google.com/file/d/1-kYL_hQD1cnH_u-jqT1SDtXjQP74oJ2p/view?usp=sharing)  
После создания воркспейсов командой workspace new %workspacename% имеем:  

```
PS C:\temp\terraform-07-3> .\terraform.exe workspace list    
  default
* prod
  stage
```
Делаем инит:
```
PS C:\temp\terraform-07-3> .\terraform.exe init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v3.67.0...
- Installed hashicorp/aws v3.67.0 (signed by HashiCorp)

Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```
Делаем план и апплай для прода:
```
PS C:\temp\terraform-07-3> .\terraform.exe plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following     
symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.bucket[0] will be created
  + resource "aws_s3_bucket" "bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "terr-07-3-bucket-0-prod"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Environment" = "prod"
          + "Name"        = "Bucket 0"
        }
      + tags_all                    = {
          + "Environment" = "prod"
          + "Name"        = "Bucket 0"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

  # aws_s3_bucket.bucket[1] will be created
  + resource "aws_s3_bucket" "bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "terr-07-3-bucket-1-prod"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Environment" = "prod"
          + "Name"        = "Bucket 1"
        }
      + tags_all                    = {
          + "Environment" = "prod"
          + "Name"        = "Bucket 1"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run
"terraform apply" now.
PS C:\temp\terraform-07-3> .\terraform.exe apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following
symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.bucket[0] will be created
  + resource "aws_s3_bucket" "bucket" {
      + acceleration_status         = (known after apply)      
      + acl                         = "private"
      + arn                         = (known after apply)      
      + bucket                      = "terr-07-3-bucket-0-prod"
      + bucket_domain_name          = (known after apply)      
      + bucket_regional_domain_name = (known after apply)      
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)      
      + id                          = (known after apply)      
      + region                      = (known after apply)      
      + request_payer               = (known after apply)      
      + tags                        = {
          + "Environment" = "prod"
          + "Name"        = "Bucket 0"
        }
      + tags_all                    = {
          + "Environment" = "prod"
          + "Name"        = "Bucket 0"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

  # aws_s3_bucket.bucket[1] will be created
  + resource "aws_s3_bucket" "bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "terr-07-3-bucket-1-prod"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Environment" = "prod"
          + "Name"        = "Bucket 1"
        }
      + tags_all                    = {
          + "Environment" = "prod"
          + "Name"        = "Bucket 1"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions in workspace "prod"?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_s3_bucket.bucket[0]: Creating...
aws_s3_bucket.bucket[1]: Creating...
aws_s3_bucket.bucket[1]: Creation complete after 5s [id=terr-07-3-bucket-1-prod]
aws_s3_bucket.bucket[0]: Creation complete after 5s [id=terr-07-3-bucket-0-prod]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
Делаем план и апплай для стейджа:
```
PS C:\temp\terraform-07-3> .\terraform.exe workspace select stage
Switched to workspace "stage".
PS C:\temp\terraform-07-3> .\terraform.exe plan

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following     
symbols:
  + create

Terraform will perform the following actions:

  + resource "aws_s3_bucket" "bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "terr-07-3-bucket-0-stage"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Environment" = "stage"
          + "Name"        = "Bucket 0"
        }
      + tags_all                    = {
          + "Environment" = "stage"
          + "Name"        = "Bucket 0"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

───────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────────── 

Note: You didn't use the -out option to save this plan, so Terraform can't guarantee to take exactly these actions if you run
"terraform apply" now.
PS C:\temp\terraform-07-3> .\terraform.exe apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following     
symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.bucket[0] will be created
  + resource "aws_s3_bucket" "bucket" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "terr-07-3-bucket-0-stage"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Environment" = "stage"
          + "Name"        = "Bucket 0"
        }
      + tags_all                    = {
          + "Environment" = "stage"
          + "Name"        = "Bucket 0"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

Plan: 1 to add, 0 to change, 0 to destroy.

Do you want to perform these actions in workspace "stage"?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_s3_bucket.bucket[0]: Creating...
aws_s3_bucket.bucket[0]: Creation complete after 4s [id=terr-07-3-bucket-0-stage]

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.
```
**Для варианта с for each создал папку 4each, поместил туда main.tf такого содержания:**

```
provider "aws" {
        region = "eu-central-1"
}

locals {
  foreach_buckets = toset([
    "4-1",
    "4-2",
  ])
}
resource "aws_s3_bucket" "terr-07-3-4" {
  for_each = local.foreach_buckets
  bucket = "terr-07-3-${each.key}-${terraform.workspace}"
  acl    = "private"
  tags = {
    Name        = "Bucket-07-3-4 ${each.key}"
    Environment = terraform.workspace
  }
  lifecycle {
      create_before_destroy = true
  }
}
```
Запускаем
```
PS C:\temp\terraform-07-3> .\terraform.exe -chdir=4each init

Initializing the backend...

Initializing provider plugins...
- Finding latest version of hashicorp/aws...
- Installing hashicorp/aws v3.68.0...
- Installed hashicorp/aws v3.68.0 (signed by HashiCorp)
Terraform has created a lock file .terraform.lock.hcl to record the provider
selections it made above. Include this file in your version control repository
you run "terraform init" in the future.

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.

PS C:\temp\terraform-07-3> .\terraform.exe -chdir=4each apply

Terraform used the selected providers to generate the following execution plan. Resource actions are indicated with the following     
symbols:
  + create

Terraform will perform the following actions:

  # aws_s3_bucket.terr-07-3-4["4-1"] will be created
  + resource "aws_s3_bucket" "terr-07-3-4" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "terr-07-3-4-1-default"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Environment" = "default"
          + "Name"        = "Bucket-07-3-4 4-1"
        }
      + tags_all                    = {
          + "Environment" = "default"
          + "Name"        = "Bucket-07-3-4 4-1"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

  # aws_s3_bucket.terr-07-3-4["4-2"] will be created
  + resource "aws_s3_bucket" "terr-07-3-4" {
      + acceleration_status         = (known after apply)
      + acl                         = "private"
      + arn                         = (known after apply)
      + bucket                      = "terr-07-3-4-2-default"
      + bucket_domain_name          = (known after apply)
      + bucket_regional_domain_name = (known after apply)
      + force_destroy               = false
      + hosted_zone_id              = (known after apply)
      + id                          = (known after apply)
      + region                      = (known after apply)
      + request_payer               = (known after apply)
      + tags                        = {
          + "Environment" = "default"
          + "Name"        = "Bucket-07-3-4 4-2"
        }
      + tags_all                    = {
          + "Environment" = "default"
          + "Name"        = "Bucket-07-3-4 4-2"
        }
      + website_domain              = (known after apply)
      + website_endpoint            = (known after apply)

      + versioning {
          + enabled    = (known after apply)
          + mfa_delete = (known after apply)
        }
    }

Plan: 2 to add, 0 to change, 0 to destroy.

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value: yes

aws_s3_bucket.terr-07-3-4["4-1"]: Creating...
aws_s3_bucket.terr-07-3-4["4-2"]: Creating...
aws_s3_bucket.terr-07-3-4["4-1"]: Creation complete after 4s [id=terr-07-3-4-1-default]
aws_s3_bucket.terr-07-3-4["4-2"]: Creation complete after 4s [id=terr-07-3-4-2-default]

Apply complete! Resources: 2 added, 0 changed, 0 destroyed.
```
