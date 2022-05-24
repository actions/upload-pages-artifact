# Upload-Pages-Artifact

A composite action for packaging and uploading artifact that can be deployed to [GitHub Pages][pages].

# Scope

⚠️ Official support for building Pages with Actions is in public beta at the moment. The scope is currently limited to **public repositories only**.

# Usage

See [action.yml](action.yml)

<!-- TODO: document custom workflow -->

# Release instructions

In order to release a new version of this Action:

1. Locate the semantic version of the upcoming release (a draft is maintained by the [`draft-release` workflow][draft-release])

2. Push a matching tag, for instance for `v0.1.0`:

   ```bash
   git tag v0.1.0
   git push origin v0.1.0
   ```

3. Publish the draft release (the major tag such as `v0` will be created/updated by the [`release` workflow][release])

   ⚠️ Environment approval is required.

# License

The scripts and documentation in this project are released under the [MIT License](LICENSE).

<!-- references -->
[pages]: https://pages.github.com
[draft-release]: .github/workflows/draft-release.yml
[release]: .github/workflows/release.yml