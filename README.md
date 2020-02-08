# WP Engine Deploy w/ Github Actions

For deploying in a similar way using a service like [Codeship](https://www.codeship.com) check out [this other linchpin repo](https://github.com/linchpin/wpengine-codeship-continuous-deployment)

This GitHub Action deploys your theme or plugin in `GITHUB_WORKSPACE` to a WP Engine install via [Git Push](https://wpengine.com/git/). 

Love WordPress? Love WP Engine and want to take advantage of their git deployment but need to have more flexibility to deploy multiple repos? This script will assist you in automatically deploying WordPress plugins and themes to [WP Engine .git deployment](https://wpengine.com/git/) using [Codeship](https://codeship.com) or other deployment services.

# Public Release Version 1.1

### Important Changes Regarding the build process compared to v1.0

* This action will *ONLY* *deploy* your code. Previously in version 1.0 this script would build your project as well.
* In order to build your project take a look at our other action [Linchpin Build Action](https://github.com/linchpin/action-build-yarn-npm)
* This deployment action not longer supports WP Engine legacy staging. We recommend using the new multi environment setups

### The instructions and the deployment script assumes the following

* You are using Github for your repo.
* You understand how to setup [.git deployments on WP Engine](https://wpengine.com/git/) already.
* You are using the **master** branch of your repo for your **Production** instance
* You are using the **staging** branch of your repo for your **Staging** instance
* You are using the **develop** branch of your repo for your **Development** instance

### How do I get set up?

* [Preflight Repo Setup](https://github.com/linchpin/action-wpengine-deploy#preflight-repo-setup)
* [Configuration](https://github.com/linchpin/action-wpengine-deploy#configuration)
* [Github Repo Secrets for Environment Variables](https://github.com/linchpin/action-wpengine-deploy#secrets)
* Deployment instructions
* [Useful notes](https://github.com/linchpin/action-wpengine-deploy#useful-notes)
* What this repo needs

### Preflight Repo Setup

When creating your repo, it's important to name the repo using proper folder structure. We typically replace any spaces " " with dashes "-".**Example:** If your plugin is named "My Awesome Plugin" you can name the repo "my-awesome-plugin". When the script runs it will use the `REPO_NAME` environment variable as the folder for your plugin or theme. So you may find it useful to match.

**Important Note:** All assets/files within your repo should be within the root folder. **DO NOT** include `wp-content`, `wp-content\plugins` etc. The deploy script will create all the appropriate folders as needed.

### Configuration

1. Within your github repo: setup [Environment Variables](https://github.com/linchpin/action-wpengine-deploy#secrets)
    * Environment variables are a great way to add flexibility to the script with out having variables hard coded within this script.
    * You should never have any credentials stored within this or any other repo.
2. Create a new workflow for each branch you are going to add automated deployments to (For single install setups use **"master"** and **"develop"**. For multi-environment setups use **master**, **staging**, and **"develop"**). The pipelines you create are going to utilize the **deployment script below**
3. Do a test push to the repo. The first time you do this, it may be beneficial to watch all the steps that are displayed within their helpful console.

### Secrets

All of the environment variables (secrets) below are required

|Variable|Description|Required|
| ------------- | ------------- | ------------- |
|**WPE_SSH_KEY_PRIVATE**|Private SSH key of your WP Engine git deploy user. See below for SSH key usage.|:heavy_exclamation_mark:|
|**WPE_SSH_KEY_PUBLIC**|Public SSH key of your WP Engine git deploy user. See below for SSH key usage.|:heavy_exclamation_mark:|
|**REPO_NAME**|The repo name should match the theme / plugin folder name|:heavy_exclamation_mark:|
|**WPE_INSTALL**|The subdomain of your WP Engine install|:heavy_exclamation_mark:|
|**PROJECT_TYPE**|(**"theme"** or **"plugin"**) This really just determines what base folder your repo should be deployed to|:heavy_exclamation_mark:|

The variable below is required to work with WP Engine's current multi-environment setup. Moving away from legacy staging, WP Engine now utilizes 3 individual installs under one "site". The are all essentially part of your same hosting environment, but are treated as Production, Staging, and Development environments (with their own subdomains). They can be considered multiple workflows that can have individual github actions.

|Variable|Description|Required|
| ------------- | ------------- | ------------- |
|**WPE_INSTALL**|The subdomain from WP Engine install||

This variable is optional to source a custom excludes list file.

|Variable|Description|Required|
| ------------- | ------------- | ------------- |
|**EXCLUDE_LIST**|Custom list of files/directories that will be used to exclude files from deployment. This shell script provides a default. This Environment variable is only needed if you are customizing for your own usage. This variable should be a FULL URL to a file. See exclude-list.txt for an example| Optional

### Commit Message Hash Tags
You can customize the actions taken by the deployment script by utilizing the following hashtags within your commit message

|Commit #hashtag|Description|
| ------------- | ------------- |
|**#force**|Some times you need to disregard what WP Engine has within their remote repo(s) and start fresh. [Read more](https://wpengine.com/support/resetting-your-git-push-to-deploy-repository/) about it on WP Engine.|

## Deployment Instructions (The Script)

The below build script(s) will check out the linchpin build scripts from github and then run the shell script accordingly based on the environment variables.

In the script below you will see this script is specifically for **master** if you wanted to use this for staging you would setup a deployment that targets **develop** specifically.

### deploying to your pipeline (master|develop - deprecated | or master|staging|develop)

In order to deploy to your pipeline you can use the following command regardless of master, develop or a custom branch. We are utilizing `https` instead of `SSH` so we can `git clone` the deployment script without requiring authentication.

**Example Basic Workflow:**
```
name: Deploy to WPEngine
on:
  push:
    branches:
      - 'master'
      - 'staging'

jobs:
  build:
    runs-on: ubuntu-latest
    steps:
      - name: Checkout code
        uses: actions/checkout@v2
        with:
          path: clone
      - name: Deploy to WP Engine
        id: wpengine_deploy
        uses: linchpin/action-wpengine-deploy@master
        env:
          PROJECT_TYPE: ${{ secrets.PROJECT_TYPE }}
          REPO_NAME: ${{ secrets.REPO_NAME }}
          WPE_SSH_KEY_PRIVATE: ${{ secrets.WPE_SSH_KEY_PRIVATE }}
          WPE_SSH_KEY_PUBLIC: ${{ secrets.WPE_SSH_KEY_PUBLIC }}
          WPE_INSTALL: ${{ secrets.WPE_INSTALL }}
```

![Linchpin](https://github.com/linchpin/brand-assets/raw/master/github-opensource-banner.png)

## Useful Notes

* WP Engine's .git push can almost be considered a "middle man" between your repo and what is actually displayed to your visitors within the root web directory of your website. After the files are .git pushed to your production, staging, or develop remote branches they are then synced to the appropriate environment's webroot. It's important to know this because there are scenarios where you may need to use the **#force** hashtag within your commit message in order to override what WP Engine is storing within it's repo and what is shown when logged into SFTP. You can read more about it on [WP Engine](https://wpengine.com/support/resetting-your-git-push-to-deploy-repository/)

* If an SFTP user in WP Engine has uploaded any files to staging or production those assets **WILL NOT** be added to the repo.
* Additionally there are times where files need to deleted that are not associated with the repo. In these scenarios we suggest deleting the files using SFTP and then utilizing the **#force** hash tag within the next deployment you make.

### What does this repo need

* Tests and Validation
* Complete documentation for usage (setup pipelines, testing etc).
