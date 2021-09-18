# Contributing to openebs/charts

openebs/charts uses the standard GitHub pull requests process to review and accept contributions.

You can contribute to openebs/charts by filling an issue at [openebs/openebs](https://github.com/openebs/openebs/issues) or submitting a pull request to this repository.

* If you want to file an issue for bug or feature request, please see [Filing an issue](#filing-an-issue)
* If you are a first-time contributor, please see [Steps to Contribute](#steps-to-contribute) and code standard(code-standard.md).
* If you would like to work on something more involved, please connect with the OpenEBS Contributors. See [OpenEBS Community](https://github.com/openebs/openebs/tree/HEAD/community)

## Filing an issue

### Before filing an issue

If you are unsure whether you have found a bug, please consider asking in the [Slack](https://kubernetes.slack.com/messages/openebs) first. If the behavior you are seeing is confirmed as a bug or issue, it can easily be re-raised in the [issue tracker](https://github.com/openebs/openebs/issues/new).


## Steps to Contribute

OpenEBS is an Apache 2.0 Licensed project and all your commits should be signed with Developer Certificate of Origin. See [Sign your work](#sign-your-work).

* Find an issue to work on or create a new issue. The issues are maintained at [openebs/openebs](https://github.com/openebs/openebs/issues).
* Claim your issue by commenting your intent to work on it to avoid duplication of efforts.
* Fork the repository on GitHub.
* Create a branch from where you want to base your work (usually main).
  - If you are updating helm charts, create a branch from main. 
  - If you are updating an artifact, create a branch from gh-pages.
* Commit your changes by making sure the commit messages convey the need and notes about the commit.
* Push your changes to the branch in your fork of the repository.
* Submit a pull request to the original repository. See [Pull Request checklist](#pull-request-checklist)

## Pull Request Checklist
* Rebase to the current HEAD branch before submitting your pull request.
* Commits should be as small as possible. Each commit should follow the checklist below:
  - For code changes, add tests relevant to the fixed bug or new feature.
  - Commit header (first line) should convey what changed
  - Commit body should include details such as why the changes are required and how the proposed changes help
  - DCO Signed, please refer [signing commit](#sign-your-commits)
* PR title must follow convention: `<type>(<scope>): <subject>`.

  For example:
  ```
   feat(charts): add support for OpenEBS 1.11
   ^--^ ^-----^   ^-----------------------^
     |     |         |
     |     |         +-> PR subject, summary of the changes
     |     |
     |     +-> scope of the PR, i.e. component of the project this PR is intend to update
     |
     +-> type of the PR.
  ```

    Most common types are:
    * `feat`        - for new features, not a new feature for the build script
    * `fix`         - for bug fixes or improvements, not a fix for the build script
    * `chore`       - changes not related to production code
    * `docs`        - changes related to documentation
    * `style`       - formatting, missing semicolons, linting fix, etc; no significant production code changes
    * `test`        - adding missing tests, refactoring tests; no production code change
    * `refactor`    - refactoring production code, eg. renaming a variable or function name, there should not be any significant production code changes
    * `cherry-pick` - if PR is merged in the HEAD branch and raised to release branch(like v1.9.x)

## Code Reviews
All submissions, including submissions by project members, require review. We use GitHub pull requests for this purpose. Consult [GitHub Help](https://help.github.com/en/github/collaborating-with-issues-and-pull-requests/about-pull-requests) for more information on using pull requests.

* If your PR is not getting reviewed or you need a specific person to review it, please reach out to the OpenEBS Contributors. See [OpenEBS Community](https://github.com/openebs/openebs/tree/HEAD/community)

* If PR is fixing any issues from [github-issues](github.com/openebs/openebs/issues) then you need to mention the issue number with a link in PR description. like: _fixes https://github.com/openebs/openebs/issues/56_

## Sign your commits

We use the Developer Certificate of Origin (DCO) as an additional safeguard for the OpenEBS projects. This is a well established and widely used mechanism to assure that contributors have confirmed their right to license their contribution under the project's license. Please read [dcofile](https://github.com/openebs/openebs/blob/HEAD/contribute/developer-certificate-of-origin). If you can certify it, then just add a line to every git commit message:

````
  Signed-off-by: Random J Developer <random@developer.example.org>
````

