# upload-pages-artifact

A composite Action for packaging and uploading artifact that can be deployed to [GitHub Pages][pages].

## Usage

See [action.yml](action.yml) for the various `inputs` this action supports (or [below](#inputs-📥)).

We recommend this action to be used in the build job:

```yaml
jobs:
  # Build job
  build:

    # Specify runner +  build & upload the static files as an artifact
    runs-on: ubuntu-latest
    steps:
			- name: Build static files
				id: build
				run: |
					# <Not provided for brevity>
					# At a minimum this step should build the static files of your site
					# <Not provided for brevity>

      - name:  Upload static files as artifact
        id: deployment
        uses: actions/upload-pages-artifact@v3 # or specific "vX.X.X" version tag for this action
				with:
					path: build_outputs_folder/

  # Deployment job
  deploy:
    environment:
      name: github-pages
      url: ${{ steps.deployment.outputs.page_url }}
    runs-on: ubuntu-latest
    needs: build
    steps:
      - name: Deploy to GitHub Pages
        id: deployment
        uses: actions/deploy-pages@v4

```

### Inputs 📥

| Input            | Required? | Default                 | Description                                        |
| ---------------- | --------- | ----------------------- | -------------------------------------------------- |
| `name`           | `false`   | `github-pages`          | Artifact name                                      |
| `path`           | `true`    | `_site/` | Path of the directory containing the static assets |
| `retention-days` | `false`   | `1`                     | Duration after which artifact will expire in days  |

### Outputs 📤

| Output        | Description                              |
| ------------- | ---------------------------------------- |
| `artifact_id` | The ID of the artifact that was uploaded |


## Artifact validation

While choosing to use this action as part of your approach to deploying to GitHub Pages is technically optional, we highly recommend it since it takes care of producing (mostly) valid artifacts.

However, if you _**do not**_ choose to use this action but still want to deploy to Pages using an Actions workflow, then you must upload an Actions artifact that meets the following criteria:

- Be named `github-pages`
- Be a single [`gzip` archive][gzip] containing a single [`tar` file][tar]

The [`tar` file][tar] must:

- be under 10GB in size (we recommend under 1 GB!)
  - :warning: The GitHub Pages [officially supported maximum size limit is 1GB][pages-usage-limits], so the subsequent deployment of larger tarballs are not guaranteed to succeed &mdash; often because they are more prone to exceeding the maximum deployment timeout of 10 minutes.
  - ⛔ However, there is also an _unofficial_ absolute maximum size limit of 10GB, which Pages will not even _attempt_ to deploy.
- not contain any symbolic or hard links
- contain only files and directories

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
[pages-usage-limits]: https://docs.github.com/en/pages/getting-started-with-github-pages/about-github-pages#usage-limits
