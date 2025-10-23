data "aws_secretsmanager_secret_version" "db" {
  secret_id = aws_secretsmanager_secret.db.id
}

locals {
  db_secret        = jsondecode(data.aws_secretsmanager_secret_version.db.secret_string)
  db_host_from_rds = aws_db_instance.this.address
  db_port_from_rds = aws_db_instance.this.port

  effective_db_host = local.db_host_from_rds != "" ? local.db_host_from_rds : try(local.db_secret.host, "")
  effective_db_port = local.db_port_from_rds != 0 ? local.db_port_from_rds : try(local.db_secret.port, 3306)
}

resource "local_file" "app_env_json" {
  filename = "${path.module}/app_env.json"

  content = templatefile("${path.module}/templates/app_env.json.tmpl", {
    rails_env             = var.rails_env
    rails_log_to_stdout   = var.rails_log_to_stdout
    rails_serve_static    = var.rails_serve_static
    puma_port             = var.puma_port
    web_concurrency       = var.web_concurrency
    rails_max_threads     = var.rails_max_threads
    rails_min_threads     = var.rails_min_threads

    # handle null secret_key_base
    secret_key_base       = try(coalesce(var.secret_key_base, ""), "")

    # Database fields (read-only from Secrets Manager + RDS)
    db_name               = try(local.db_secret.database, var.db_name)
    db_host               = local.effective_db_host
    db_port               = local.effective_db_port
    db_user               = local.db_secret.username
    db_password           = local.db_secret.password

    # Office365 / SSO
    office365_client_id     = var.office365_client_id
    office365_client_secret = var.office365_client_secret
    office365_redirect_uri  = var.office365_redirect_uri
    office365_provider_url  = var.office365_provider_url

    # Keycloak
    keycloak_client_id     = var.keycloak_client_id
    keycloak_client_secret = var.keycloak_client_secret
    keycloak_realm         = var.keycloak_realm
    keycloak_server_url    = var.keycloak_server_url

    # SSL flag
    use_ssl                = var.use_ssl
  })

  file_permission = "0600"
}
