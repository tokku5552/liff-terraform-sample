---
theme: ./theme
highlighter: shiki
title: liffアプリをterraformで作ってみた
layout: intro
---

# liffアプリを<br/>terraformで作ってみた

2023-06-24 CloudTech LT: tokkuu

<div class="pt-12">
  <span @click="next" class="px-2 p-1 rounded cursor-pointer hover:bg-purple hover:bg-opacity-10">
    Press Space for next page <carbon:arrow-right class="inline"/>
  </span>
</div>

---
layout: default
---

# Table of contents

<Toc minDepth="1" maxDepth="1"/>

---
layout: image-x
image: /tokuda.png
---

# 自己紹介

- 2017-2022 SIerで金融系インフラエンジニア
  - Active Directory/RHEL/Oracle/VM Ware
- 2022-2023 ミロゴス株式会社
  - TypeScript/LINE API/TreasureData/AWS
- CyberAgent AI div.
  - バックエンドエンジニア
  - Go/TypeScript(Next.js/Nest.js)/AWS/Terraform
- private(Flutter/Firebase)
- 元バンドマン/2歳の娘のパパ/LINE API Expert


<ul class='flex justify-center'>
  <li class='list-none'><img src='/lae.png' width=150 /></li>
  <li class='list-none'><img src='/logo_transparent.png' width=100 /></li>
  <li class='list-none'><img src='/logo_square_transparent.png' width=100 /></li>
</ul>

---
transition: fade-out
---

# IaCのおさらい

- サーバーやネットワークなどのインフラの構成をCodeで表現して構築する
  - git管理できるので、バージョン管理やレビューが容易！
- CI/CDと組み合わせることで、コードの状態とインフラの状態を常に同じに保てる

<br/>

|ツール名 |コード定義|対象|備考|
| --| --------------------------- |--|--|
| terraform| HCL|すべてのサービス|GCPやAzureなども対応|
| SAM| yaml|サーバレスのみ||
| Cloud Formation| yaml|すべてのサービス||
| Serverless Framework| yaml|サーバレスのみ|GCPやAzureなども対応|
| AWS CDK| Python/Java/.NET/Go/TypeScript|すべてのサービス||


---
layout: quote
---

# Terraform入門しました

---

## サンプルリポジトリ
<br/>

<div class='justify-center'>
  <img src="/this_repos.png" width="700"/>
</div>

<arrow v-click="1" x1="600" y1="400" x2="700" y2="500" color="#811" width="3" arrowSize="1" />


---
layout: image-x
image: /dir.png
---

# ディレクトリ構成

```bash {all|4|7-20|8|9-14|9-14|17|18-20|all}
.
├── .github/ # GitHub Actionsなど
├── README.md
├── my-app/ # liffのコードが入ったディレクトリ(Next.js)
├── renovate.json
├── slidev/ # このスライド
└── terraform/
    ├── environments/ # 環境ごとのフォルダ
    │   ├── dev/
    │   │   ├── .terraform
    │   │   ├── .terraform.lock.hcl
    │   │   ├── main.tf
    │   │   ├── provider.tf
    │   │   └── variable.tf
    │   ├── prd/
    │   └── stg/
    └── modules/ # moduleフォルダ
        └── static-page/
            ├── cloudfront.tf
            └── s3.tf
```

<arrow v-click="5" x1="400" y1="420" x2="240" y2="350" color="#564" width="3" arrowSize="1" />

---
layout: default
---

## environment/dev
<br/>

- main.tf

```hcl
module "static-page" {
  source = "../../modules/static-page"
}
```
<br/>

- variable.tf

```hcl
variable "account_id" {
  default = "1234567890"
}
variable "region" {
  default = "ap-northeast-1"
}
variable "environment" {
  default = "dev"
}
variable "project" {
  default = "terraform-sample"
}
```

---
layout: default
---

## environment/dev/provider.tf
<br/>

```hcl {all|4|6|7|all}
terraform {
  required_version = "~> 1.5.0"
  backend "s3" {
    bucket         = "my-tfstate-bucket-6588" # stateを保持するためのS3バケット
    region         = var.region
    key            = "dev.tfstate" # S3に保存するときのkey
    dynamodb_table = "terraform-state-lock" # state lockをかけるためのtable
  }
}

provider "aws" {
  region = var.region
  default_tags { # defaultで付与するタグ
    tags = {
      env     = var.environment
      project = var.project
      owner   = "terraform"
      tfstate = "dev"
    }
  }
}
```

---
layout: default
---

## modules - s3
<br/>

```hcl 
resource "aws_s3_bucket" "bucket" {
  bucket_prefix = "static-www"
}

resource "aws_s3_bucket_website_configuration" "static-www" {
  bucket = aws_s3_bucket.bucket.id
  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

...
```

---
layout: default
---

## modules - cloudfront
<br/>

```hcl 
resource "aws_cloudfront_distribution" "static-www" {
    origin {
        domain_name = aws_s3_bucket.bucket.bucket_regional_domain_name
        origin_id = aws_s3_bucket.bucket.id # originに先程のS3を指定する
        s3_origin_config {
          origin_access_identity = aws_cloudfront_origin_access_identity.static-www.cloudfront_access_identity_path
        }
    }
    default_root_object = "index.html"
    default_cache_behavior {
        allowed_methods = [ "GET", "HEAD" ]
        cached_methods = [ "GET", "HEAD" ]
        target_origin_id = aws_s3_bucket.bucket.id # originに先程のS3を指定する
        forwarded_values {
            query_string = false
            cookies {
              forward = "none"
            }
        }

...
```

---
layout: default
---

## デプロイ

```bash {99|1|2|3|4|6-10|all}
cd terraform/environments/dev
terraform init
terraform plan
terraform apply

cd ../../../my-app
yarn export
cd ..
aws s3 sync ./my-app/out s3://<bucket name>
aws cloudfront create-invalidation --distribution-id <distribution id> --paths "/*"
```

<br/><br/>
<img v-click="6" src="/deploy.png" width="800">

---

# まとめ

- terraform意外とわかりやすい
- CloudFront + S3のひな形できたので、今後modulesごと持っていけば流用も容易そう

---

## 宣伝 その1
<a href="https://podcasters.spotify.com/pod/show/5rh9uag8ah" >
  <img src="/advertise1.png" width="800" />
</a>

--- 

## 宣伝 その2
<a href="https://hrmos.co/pages/cyberagent-group/jobs/1833170313527164963" >
  <img src="/advertise2.png" width="800" />
</a>