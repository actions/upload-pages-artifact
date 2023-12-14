# upload-pages-artifact

A composite Action for packaging and uploading artifact that can be deployed to [GitHub Pages][pages].

## Scope

⚠️ Official support for building Pages with Actions is in public beta at the moment.

## Usage

See [action.yml](action.yml)

<!-- TODO: document custom workflow -->

## Artifact validation

While using this action is optional, we highly recommend it since it takes care of producing (mostly) valid artifacts.

A Pages artifact must:

- Be called `github-pages`
- Be a single [`gzip` archive][gzip] containing a single [`tar` file][tar]

The [`tar` file][tar] must:

- be under 10GB in size
- not contain any symbolic or hard links
- contain only files and directories that all meet the expected minimum [file permissions](#file-permissions)

### File permissions

When using this action, ensure that your files have appropriate file permissions.
At a minimum, GitHub Pages expects:
- files to have read permission for the current user and the "Others" user role (e.g. `0744`, `0644`, `0444`)
- directories to have read and execute permissions for the current user and the "Others" user role (e.g. `0755`, `0555`)

Failure to supply adequate permissions will result in a `deployment_perms_error` when attempting to deploy your artifacts to GitHub Pages.

#### Example permissions fix for Linux

```yaml
steps:
# ...
  - name: Fix permissions
    run: |
      chmod -c -R +rX "_site/" | while read line; do
        echo "::warning title=Invalid file permissions automatically fixed::$line"
      done
  - name: Upload Pages artifact
    uses: actions/upload-pages-artifact@v3
# ...
```

#### Example permissions fix for Mac

```yaml
steps:
# ...
  - name: Fix permissions
    run: |
      chmod -v -R +rX "_site/" | while read line; do
        echo "::warning title=Invalid file permissions automatically fixed::$line"
      done
  - name: Upload Pages artifact
    uses: actions/upload-pages-artifact@v3
# ...
```

## Release instructions

In order to release a new version of this Action:

1. Locate the semantic version of the [upcoming release][release-list] (a draft is maintained by the [`draft-release` workflow][draft-release]).

2. Publish the draft release from the `main` branch with semantic version as the tag name, _with_ the checkbox to publish to the GitHub Marketplace checked. :ballot_box_with_check:

3. After publishing the release, the [`release` workflow][release] will automatically run to create/update the corresponding the major version tag such as `v0`.

   ⚠️ Environment approval is required. Check the [Release workflow run list][release-workflow-runs].

## License

The scripts and documentation in this project are released under the [MIT License](LICENSE).

<!-- references -->
[pages]: https://pages.github.com
[release-list]: https://github.com/actions/upload-pages-artifact/releases
[draft-release]: .github/workflows/draft-release.yml
[release]: .github/workflows/release.yml
[release-workflow-runs]: https://github.com/actions/upload-pages-artifact/actions/workflows/release.yml
[gzip]: https://en.wikipedia.org/wiki/Gzip
[tar]: https://en.wikipedia.org/wiki/Tar_(computing)
