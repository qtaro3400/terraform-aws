# -----------------------------
# Key Pair
# -----------------------------
locals {
  key_name = "${var.project}-${var.env}-pemkey"
  ## NOTE: 作成したキーペアを格納するファイルを指定。存在しないディレクトリは自動作成してくれる。
  public_key_file = "./secure/key_pair/${local.key_name}.id_rsa.pub"
  private_key_file = "./secure/key_pair/${local.key_name}.id_rsa"
}

## NOTE: private keyのアルゴリズム指定
resource "tls_private_key" "keygen" {
  algorithm = "RSA"
  rsa_bits = 4096
}

## NOTE: local_fileリソースを使うとterraformを実行するディレクトリ内でファイル作成やコマンド実行ができる。
resource "local_file" "public_key_openssh" {
  filename = local.public_key_file
  content = tls_private_key.keygen.public_key_openssh
  provisioner "local-exec" {
    command = "chmod 600 ${local.public_key_file}"
  }
}

resource "local_file" "private_key_pem" {
  filename = local.private_key_file
  content = tls_private_key.keygen.private_key_pem
  provisioner "local-exec" {
    command = "chmod 600 ${local.private_key_file}"
  }
}

resource "aws_key_pair" "key_pair" {
  key_name = local.key_name
  public_key = tls_private_key.keygen.public_key_openssh
}