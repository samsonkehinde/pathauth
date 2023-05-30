# Pathauth

Pathauth is a middleware plugin for [Traefik](https://github.com/traefik/traefik) to apply more detailed authorization
to multiple endpoints at once.

## Configuration

### Static

```yaml
experimental:
  plugins:
    pathauth:
      moduleName: "github.com/samsonkehinde/accessauth"
      version: "v0.1"
```

### Dynamic

```yaml
http:
  middlewares:
    accessauth:
      acl:
        authorization:
          - rules:
            - host:
                      - "^melon.app$" # regex, optional, multiple hosts allowed				
              path:
                      - "/user/.*" # regex, multiple paths allowed
                      - "/sp/.*"
                      - "/vehicle/.*"
                      - "/gps/.*"
              role:
                - "driver"
                - "customer"
            - host:
                      - "^melon.app$" # regex, optional, multiple hosts allowed				
              path:
                      - "/users" #
                      - "/"
              role:
                - "admin"
```

### Authorization requirements

* A request will only be declined, by way of a 403 response, when an authentication rule doesn not match on path, host and role.
* If a request does match to path, host and role it will directly be allowed.
