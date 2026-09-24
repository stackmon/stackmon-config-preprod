pid_file = "/home/vault/pidfile"

auto_auth {
    method "kubernetes" {
        mount_path = "auth/kubernetes"
        config = {
            role = "sd3"
            token_path = "/var/run/secrets/tokens/vault-token"
        }
    }
    sink "file" {
        config = {
            path = "/home/vault/.vault-token"
        }
    }
}

template {
  destination = "/secrets/sd3-api-env"
  contents = <<EOT
{{ with secret "secret/data/statusdashboard/sd3-test" -}}
export SD_DB={{ .Data.data.dburl }}
{{- end }}
export SD_CACHE=internal
export SD_LOG_LEVEL=devel
export SD_OIDC_ISSUER=https://zitadel.eco-preprod.tsi-dev.otc-service.com
export SD_OIDC_CLIENT_ID=390700708019568682
export SD_OIDC_USERNAME_CLAIM=client_id
export SD_RBAC_ROLES_ADMINS=sd_admins
export SD_RBAC_ROLES_OPERATORS=sd_operators
export SD_RBAC_ROLES_CREATORS=sd_creators
export SD_RBAC_ROLES_REPORTERS=sd_reporters
EOT
  perms = "0664"
}
