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
export SD_CACHE=internal
export SD_LOG_LEVEL=devel
# The OBS static website endpoint the backend proxies every path the API does
# not own. Host only: OBS picks the bucket from the Host header and ignores SNI.
export SD_STATIC_ORIGINS=status-dashboard-test.obs-website.eu-de.otc.t-systems.com
export SD_OIDC_ISSUER=https://zitadel.eco-preprod.tsi-dev.otc-service.com
export SD_OIDC_CLIENT_ID=390700708019568682
export SD_OIDC_USERNAME_CLAIM=client_id
export SD_RBAC_ROLES_ADMINS=sd_admins
export SD_RBAC_ROLES_OPERATORS=sd_operators
export SD_RBAC_ROLES_CREATORS=sd_creators
export SD_RBAC_ROLES_REPORTERS=sd_reporters
# Maintenance email notifications (PR #42). SMTP goes through the OTC Secure
# Mail Gateway; the password is injected from Vault.
export SD_NOTIFICATIONS_ENABLED=true
export SD_NOTIFICATIONS_LEASE_TIMEOUT=60s
export SD_NOTIFICATIONS_MAX_ATTEMPTS=5
export SD_NOTIFICATIONS_BACKOFF_INTERVAL=5m
export SD_NOTIFICATIONS_SMOD_EMAIL=aloento@outlook.com
export SD_NOTIFICATIONS_EMAILS_OPERATORS=aloento@outlook.com
export SD_NOTIFICATIONS_EMAILS_ADMINS=aloento@outlook.com
export SD_WEB_URL=https://test.status.otc-service.com
export SD_SMTP_HOST=otc-de-out.mms.t-systems-service.com
export SD_SMTP_PORT=25
export SD_SMTP_FROM=otc00000000001000000448_3@otc-eu-de.mms.t-systems-service.com
export SD_SMTP_USER=otc00000000001000000448_3@otc-eu-de.mms.t-systems-service.com
export SD_SMTP_PASSWORD={{ .Data.data.smtp_password }}
export SD_SMTP_TLS=false
export SD_SMTP_TIMEOUT=30s
{{- end }}
EOT
  perms = "0664"
}
