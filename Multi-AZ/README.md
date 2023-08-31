# 構成図
![](./arc.png)

## 変数
1. ルートディレクトリに`terraform.tfvar`を作成。
2. domain_name = "取得したドメイン名" という１行を追加。

## デプロイ
```
$ terraform init
$ terraform apply
```