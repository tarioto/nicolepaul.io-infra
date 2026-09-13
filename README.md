# nicolepaul.io-infra

Shared AWS host for nicolepaul.io's small Dash dashboards. One always-on EC2
instance runs every app as a Docker container, fronted by Caddy (automatic
HTTPS + per-domain reverse proxy). Provisioned with [OpenTofu](https://opentofu.org/).

## Usage

```sh
tofu init
tofu plan
tofu apply
```

State is local (`terraform.tfstate`, gitignored) — fine for a single-operator
setup. If this ever needs multiple people applying changes, migrate to an S3
backend first.

After `apply`, wire up each app:

1. Point that app's DNS A record at the `elastic_ip` output.
2. In that app's GitHub repo, set these Actions variables (Settings ->
   Secrets and variables -> Actions -> Variables) from the Tofu outputs:
   - `AWS_REGION`
   - `AWS_DEPLOY_ROLE_ARN` (from `deploy_role_arns[<app>]`)
   - `ECR_REPOSITORY` (the app's key in `var.apps`, e.g. `dash-ushh-displacement`)
   - `EC2_INSTANCE_ID` (from `instance_id`)

## Adding a new app

Add an entry to the `apps` map in `variables.tf`:

```hcl
apps = {
  dash-ushh-displacement = {
    github_repo = "nicolepaul/dash-ushh-displacement"
    domain      = "hps.nicolepaul.io"
  }
  some-new-dashboard = {
    github_repo = "nicolepaul/some-new-dashboard"
    domain      = "some-new-dashboard.nicolepaul.io"
  }
}
```

Then `tofu apply` — this creates the new app's ECR repo and deploy role, and
regenerates `/opt/apps/docker-compose.yml` / `Caddyfile` on the host via
`user_data` on the next instance replacement. Because `user_data` only runs
on first boot, apply the compose/Caddyfile changes to the running host by
hand after `apply` (SSM into the box, or re-run the relevant `cat > ...
<<EOF` blocks from `user_data.sh.tftpl`) rather than replacing the instance.
