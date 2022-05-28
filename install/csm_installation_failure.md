# CSM Installation Failure

This page documents a possible timing related issue in a new CSM install.

## Details

<a name="verify_missing_secret"></a>
### 1. Verify Missing Secret

   1. Verify installation output signature matches

      ```bash
      ...
        ERROR   Step: Set Management NCNs to use Unbound --- Checking Precondition
      + Getting admin-client-auth secret
      Error from server (NotFound): secrets "admin-client-auth" not found
      + Obtaining access token
      curl: (22) The requested URL returned error: 404
      + Querying SLS
      curl: (22) The requested URL returned error: 503

      Check the doc below for troubleshooting:
            If any management NCNs are missing from the output, take corrective action
            before proceeding.

       INFO  Failed Pipeline/Step id: f0cd9574240989eb04118d308f26b3ea
      exit status 22
      ```

      Perform this procedure when observed. The root cause is simply a timing issue.

<a name="validate_keycloak_setup_is_running"></a>
### 1. Validate Keycloak Setup Is Running

   1. To ensure keycloak-setup has the issue, look for a keycloak-setup pod still in a Running state:

      ```bash
      pit # kubectl get pods --namespace services | grep keycloak-setup
      keycloak-setup-1-xj9s5                                            1/2     Running   0          32m
      ```

    Look at the istio-proxy container logs for this signature:

      ```bash
      pit # kubectl logs --namespace services -n services keycloak-setup-1-xj9s5 --container istio-proxy | grep '[[:space:]]503[[:space:]]' | grep SDS | tail -n2
      [2022-05-27T13:21:24.535Z] "POST /keycloak/realms/master/protocol/openid-connect/token HTTP/1.1" 503 UF,URX "TLS error: Secret is not supplied by SDS" 96 159 16 - "-" "python-requests/2.27.1" "19fe9b72-d887-4649-b934-9dc7bc76cc21" "keycloak.services:8080" "10.44.0.31:8080" outbound|8080||keycloak.services.svc.cluster.local - 10.28.81.125:8080 10.32.0.25:60032 - default
      [2022-05-27T13:21:34.573Z] "POST /keycloak/realms/master/protocol/openid-connect/token HTTP/1.1" 503 UF,URX "TLS error: Secret is not supplied by SDS" 96 159 61 - "-" "python-requests/2.27.1" "ef0255b4-260b-47b5-8077-3e17e9371baf" "keycloak.services:8080" "10.44.0.31:8080" outbound|8080||keycloak.services.svc.cluster.local - 10.28.81.125:8080 10.32.0.25:60964 - default
      ```

<a name="keycloak_setup_workaround"></a>
### 1. Keycloak Setup Workaround

   1. To work around this issue we simply need to delete the current keycloak-setup pod manually:

      ```bash
      pit # kubectl delete pod --namespace services keycloak-setup-1-xj9s5
      ```

      Ensure new keycloak-setup pod completed setup:

      ```bash
      pit # kubectl logs --namespace services -n services keycloak-setup-2-xz1hr --container keycloak-setup | tail -n 3
      2022-05-27 14:12:25,251 - INFO    - keycloak_setup - Deleting 'keycloak-gatekeeper-client' Secret in namespace 'services'...
      2022-05-27 14:12:25,264 - INFO    - keycloak_setup - The 'keycloak-gatekeeper-client' secret in namespace 'services' already doesn't exit.
      2022-05-27 14:12:25,264 - INFO    - keycloak_setup - Keycloak setup complete
      ```

      Once all keycloak pods have successfully completed installation can continue:

      ```bash
      pit # kubectl get pods --namespace services | grep keycloak | grep -Ev '(Completed|Running)'
      pit #
      ```
