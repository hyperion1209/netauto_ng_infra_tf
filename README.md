# netauto_ng_infra_tf

## Manual
### Adding a new service
1. Copy an existing service module and modify the **helm.tf** and the **values.tftpl** template files
2. Add the new service to the **enabled_services** local variable and set it to **true**
3. If the new service needs to be accessed from the internet, add an ingress by adding the new service to the **ingress_services** local variable and by adding the service module as a dependency of the **ingress** module.

## Bootstrapping
### Vault
The vault pod will fail readiness probes until it is initialized,
```
kubectl exec -it vault-0 -n vault -- vault operator init
```
and unsealed by running the following command 3 times:

```
kubectl exec -it vault-0 -n vault -- vault operator unseal
```

#### Allow TF access
https://developer.hashicorp.com/terraform/cloud-docs/workspaces/dynamic-provider-credentials/vault-configuration#configure-vault

#### Logging into the CLI
```
export VAULT_ADDR="https://your-vault-server:8200"

vault login <root_token>
vault login -method=userpass username=my-username password=my-password
```

### Keycloak
#### Initial login
Default user is: user
To get the default password after deploying the service run:
```
kubectl -n keycloak get secret keycloak -o jsonpath='{.data.admin-password}' | base64 -d && echo
```

#### Setting up credentials for terraform provider
https://registry.terraform.io/providers/linz/keycloak/latest/docs

## TODO
### General
- [x] Use native service ingress config in the helm charts - easier to use the ingress module
- [x] Get proper certificates
- [ ] Use external dbs for services that support them

### Prometheus
- [x] add persistent volumes (alertmanager too)
- [ ] Add oauth sidecar container with keycloak auth and ingress
- [ ] monitor server pvc utilization and adjust size to keep 7 days worth of data

### Keycloak
- [x] Add client dedicated scope mapper to TF code and remove the manual one
- [x] Grafana doesn't use http to access keycloak
- [x] Add dashboard and service monitor for keycloak
- [ ] Use a db to persist keycloak data
- [ ] Create and use custom docker image with keycloak-metrics-spi installed
    - repo: https://github.com/aerogear/keycloak-metrics-spi?tab=readme-ov-file
    - extending keycloak image: https://www.keycloak.org/server/containers
- [ ] Find a way to authenticate apps without the need for client secret in app config

### Oauth
- [ ] Investigate using oauth2-proxy for all services
    - docs: https://oauth2-proxy.github.io/oauth2-proxy/

### Grafana
- [x] add persistent volumes
- [ ] Make a new dashboard for kubernetes cluster monitoring
- [ ] Add sign-out url for keycloak

### Pulp
- [x] Add ingress following [link](https://pulpproject.org/pulp-operator/docs/admin/guides/configurations/networking/ingress.yaml)
- [x] Create admin account with secret password
- [x] Create test repos
- [ ] Enable metrics, service monitor and add dashboard
- [ ] Create custom image with social-auth enabled
- [ ] Enable keycloak authentication
- [ ] Build terraform provider

### VSO
- [x] Load vault secrets for all services

## Known Issues
### Grafana
- ~~Dashboards provisioned with Helm cannot be deleted: https://github.com/grafana/helm-charts/issues/2752~~

### Pulp
- Needs ReadWriteMany access to the PV but it looks like Civo doesn't support this. Should only be a problem when running multiple pods across multiple nodes. Problem can be worked around if all pods are bound to a single node.
- Enabling telemetry produces error 
