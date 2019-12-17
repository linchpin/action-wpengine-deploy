# WPEngine Deploy

This GitHub Action deploys your theme or plugin in `GITHUB_WORKSPACE` to a WPEngine install via [Git Push](https://wpengine.com/git/). 

# Required SECRETs

| Name | Type | Usage |
|-|-|-|
| `WPENGINE_SSH_KEY_PRIVATE` | Secret | Private SSH key of your WP Engine git deploy user. See below for SSH key usage. |
|  `WPENGINE_SSH_KEY_PUBLIC` | Secret | Public SSH key of your WP Engine git deploy user. See below for SSH key usage. |