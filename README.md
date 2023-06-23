# upload-pages-artifact

A composite Action for packaging and uploading artifact that can be deployed to [GitHub Pages][pages].

# Scope

⚠️ Official support for building Pages with Actions is in public beta at the moment.

# Usage
As an example you may want to build your page as a pages artifact so you can publish it using [actions/deploy-pages](https://github.com/actions/deploy-pages). This actions completes steps 1-4 from [this tutorial](https://docs.github.com/en/pages/getting-started-with-github-pages/configuring-a-publishing-source-for-your-github-pages-site#creating-a-custom-github-actions-workflow-to-publish-your-site)

```
name: Build Page + Upload artifact
on:
  push:
    branches:
      - main

jobs:
    build-upload:
    runs-on:  ubuntu-latest
    steps:
      - name: Checkout sources
        uses: actions/checkout@v3
        
      # Replace this step with your own page build process
      - name: Build your page
        run: |
          cd docs/
          make html

      # Change path to include the index of your webpage
      - name: Upload your page as github pages artifact
        uses: actions/upload-pages-artifact@main
        with:
          path: docs/build/html/
```
After you have uploaded the pages artifact, you can add another job that deploys the artifact using the [actions/deploy-pages](https://github.com/actions/deploy-pages) action

See [action.yml](action.yml) for the full parameters (This is the action itself not an example)

<!-- TODO: document custom workflow -->

# Artifact validation

While using this action is optional, we highly recommend it since it takes care of producing (mostly) valid artifacts.

A Pages artifact must:

- Be called `github-pages`
- Be a single [`gzip` archive][gzip] containing a single [`tar` file][tar]

The [`tar` file][tar] must:

- be under 10GB in size
- not contain any symbolic or hard links

# File Permissions

When using this action ensure your files have appropriate file permission, we expect at a minimum for the files to have permission for the current user (e.g 0744).
Failure to do so will result in a `deployment_perms_error` when attempting to deploy your artifacts.

```yaml
...
runs:
  using: composite
  steps:
    - name: Archive artifact
      shell: sh
      if: runner.os == 'Linux'
      run: |
        chmod -c -R +rX "$INPUT_PATH" |
        while read line; do
           echo "::warning title=Invalid file permissions automatically fixed::$line"
        done
        tar \
          --dereference --hard-dereference \
          --directory "$INPUT_PATH" \
          -cvf "$RUNNER_TEMP/artifact.tar" \
          --exclude=.git \
          --exclude=.github \
          .
      env:
        INPUT_PATH: ${{ inputs.path }}

...
```


# Release instructions

In order to release a new version of this Action:

1. Locate the semantic version of the [upcoming release][release-list] (a draft is maintained by the [`draft-release` workflow][draft-release]).

2. Publish the draft release from the `main` branch with semantic version as the tag name, _with_ the checkbox to publish to the GitHub Marketplace checked. :ballot_box_with_check:

3. After publishing the release, the [`release` workflow][release] will automatically run to create/update the corresponding the major version tag such as `v0`.

   ⚠️ Environment approval is required. Check the [Release workflow run list][release-workflow-runs].

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE).

<!-- references -->
[pages]: https://pages.github.com
[release-list]: https://github.com/actions/upload-pages-artifact/releases
[draft-release]: .github/workflows/draft-release.yml
[release]: .github/workflows/release.yml
[release-workflow-runs]: https://github.com/actions/upload-pages-artifact/actions/workflows/release.yml
[gzip]: https://en.wikipedia.org/wiki/Gzip
[tar]: https://en.wikipedia.org/wiki/Tar_(computing)
