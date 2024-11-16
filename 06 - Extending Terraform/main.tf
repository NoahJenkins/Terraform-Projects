resource "random_password" "password" {
keepers = {
    # Generate a new password
    datetime = timestamp()
  }
  length  = 16
  special = true
}

output "password" {
  value     = random_password.password.result
  sensitive = true
}

resource "random_uuid" "guid" {
  keepers = {
    datetime = timestamp()
  }
}

output "guid" {
  value = random_uuid.guid.result
}

# Generate a new RSA key pair
resource "tls_private_key" "tls" {
  algorithm = "RSA"
}

# Save the public and private keys to files
resource "local_file" "tls-public" {
  filename = "id_rsa.pub"
  content  = tls_private_key.tls.public_key_openssh
}

resource "local_file" "tls-private" {
  filename = "id_rsa.pem"
  content  = tls_private_key.tls.private_key_pem

  provisioner "local-exec" {
    command = "chmod 600 id_rsa.pem"
  }
}