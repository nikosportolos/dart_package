# dart_package

Optimize your Dart & Flutter package development workflow with the
[**dart_package**](https://github.com/marketplace/actions/dart-package) GitHub Action.

This action helps you streamline your development process cycle by automating in-depth package analysis,
running tests, tracking code-coverage with [Codecov](https://codecov.io), as well as hassle-free
publishing on [pub.dev](https://pub.dev), saving you time and effort.

## Table of contents

- [Setup](#setup)
  - [Setting up secrets in GitHub](#setting-up-secrets-in-github)
  - [Codecov](#setup-codecov)
  - [Pub.dev](#pubdev)
- [Inputs](#inputs)
- [Examples](#examples)
  - [Pull-request workflow](#pull-request-workflow)
  - [Merge workflow](#merge-workflow)
  - [Publish workflow](#publish-workflow)
  - [Flutter workflow](#flutter-workflow)
- [Changelog](#changelog)
- [Contribution](#contribution)

## Setup

### Setting up secrets in GitHub

In order to upload Coverage reports to Codecov or/and to publish a package on [pub.dev](https://pub.dev)
we need to set up the corresponding tokens as secrets in our GitHub repository.

You can find [here](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/managing-encrypted-secrets-for-your-repository-and-organization-for-github-codespaces)
more information about secrets & environment variables.

Your secrets in your GitHub repository should look like that:

<a href="https://github.com/nikosportolos/dart_package/blob/main/assets/images/github_secret.png" target="_blank">
  <img src="https://github.com/nikosportolos/dart_package/blob/main/assets/images/github_secret.png" width="80%" alt="github-secrets">
</a>

- #### Setup Codecov

The unique repository upload token is found on the settings page of your project.
You need write access to view this token.

For GitHub repositories the token will be found in `https://codecov.io/github/<owner>/<repo>/settings`.

<a href="https://github.com/nikosportolos/dart_package/blob/main/assets/images/codecov_token.png" target="_blank">
  <img src="https://github.com/nikosportolos/dart_package/blob/main/assets/images/codecov_token.png" width="80%" alt="codecov-token">
</a>

- #### Pub.dev

You can acquire your `pub-credentials.json` simply by running the command `dart pub login` and logging in to pub.dev
with your Gmail account via a browser.

The `pub-credentials.json` will be generated in the default dart config folder in your system.

You can find it depending on your OS in the following directories:

- On **Linux** _(see XDG specification)_

  - If `$XDG_CONFIG_HOME` is defined:
    - `$XDG_CONFIG_HOME/dart/pub-credentials.json`
  - else
    - `$HOME/.config/dart/pub-credentials.json`

- On **MacOS** _(see [developer.apple.com](https://developer.apple.com))_

  - `~/Library/Application Support/dart/pub-credentials.json`

- On **Windows**
  - `%APPDATA%/dart/pub-credentials.json`

Read more:

- https://pub.dev/documentation/cli_pkg/latest/cli_pkg/pubCredentials.html
- https://github.com/dart-lang/pub/issues/2999#issuecomment-908350917

> **Please notice** that the `pub-credentials.json` needs to be encoded into a base64 string
> before adding it to your repository secrets.
>
> You can easily encode it using the following command:
>
> `base64 ./pub-credentials.json > output.txt`

## Inputs

| Name                | Description                                                                                                                                                                                           | Required | Default    |
| ------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | -------- | ---------- |
| working_directory   | Specify the working directory where the workflow will run.                                                                                                                                            | false    | "."        |
| sdk                 | Specify which SDK to use (dart, flutter).                                                                                                                                                             | false    | "dart"     |
| dart_sdk            | Specify the Dart SDK version that will be used. </br> This input will be ignored if `sdk` is set to `flutter`.                                                                                        | false    | "3.4.4"    |
| flutter_sdk         | Specify the Flutter SDK version that will be used. </br> This input will be ignored if `sdk` is set to `dart`.                                                                                        | false    | "3.22.3"   |
| analyze_directories | Specify the directories where [dart analyze](https://dart.dev/tools/dart-analyze) will run.                                                                                                           | false    | "lib test" |
| line_length         | The line length to use with [dart format](https://dart.dev/tools/dart-format).                                                                                                                        | false    | "120"      |
| concurrency         | Controls the number of test suites that runs [concurrently](https://pub.dev/packages/test#test-concurrency), meaning that multiple tests in independent suites or platforms can run at the same time. | false    | "4"        |
| skip_tests          | Flag that defines whether to skip tests.                                                                                                                                                              | false    | "false"    |
| coverage            | Flag that defines whether to run tests with [coverage](https://pub.dev/packages/test#collecting-code-coverage).                                                                                       | false    | "false"    |
| codecov             | Flag that defines whether to upload coverage reports to [Codecov](https://about.codecov.io/).</br></br>**Requires the `codecov_token`.**                                                              | false    | "false"    |
| codecov_token       | The token that will be used to upload coverage reports to [Codecov](https://about.codecov.io/).</br></br>**Requires the `codecov` flag to be set to true.**                                           | false    | ""         |
| publish             | Flag that defines whether to publish the Dart package on [pub.dev](https://pub.dev/).                                                                                                                 | false    | "false"    |
| pubdev_token        | The token that will be used to publish the Dart package to [pub.dev](https://pub.dev/).                                                                                                               | false    | ""         |
| pana_threshold      | Set a threshold in [pana](https://pub.dev/packages/pana)'s analysis report.</br>The exit code will indicate if (max - granted points) <= threshold.                                                   | false    | "19"       |

## Examples

You can try the **dart_package** GitHub Action using the workflows in the [examples](https://github.com/nikosportolos/dart_package/tree/main/examples/workflows) folder.

- ### Pull-request workflow

```yaml
# .github/workflows/pr.yml
# This workflow runs on every pull-request to ensure Dart package quality.
name: PR Workflow

on:
  workflow_dispatch:
  pull_request:
    types: [opened, reopened, synchronize]

concurrency:
  group: ${{github.workflow}}-${{github.ref}}
  cancel-in-progress: true

jobs:
  build:
    defaults:
      run:
        working-directory: .
    runs-on: 'ubuntu-latest'
    steps:
      - uses: actions/checkout@v4
      - uses: nikosportolos/dart_package@v0.2.3
```

- ### Merge workflow

```yaml
# .github/workflows/merge.yml
# This workflow runs when merging code to the main branch.
name: Merge Workflow

on:
  workflow_dispatch:
  push:
    branches:
      - main

concurrency:
  group: ${{github.workflow}}-${{github.ref}}
  cancel-in-progress: true

jobs:
  build:
    defaults:
      run:
        working-directory: .
    runs-on: 'ubuntu-latest'
    steps:
      - uses: actions/checkout@v4
      - uses: nikosportolos/dart_package@v0.2.3
        with:
          coverage: true
          codecov: true
          codecov_token: ${{ secrets.CODECOV_TOKEN }}
```

- ### Publish workflow

```yaml
# .github/workflows/publish.yml
# This workflow runs when publishing a Dart package on pub.dev.
name: Publish Workflow

on:
  workflow_dispatch:
  release:
    types: [published]

concurrency:
  group: ${{github.workflow}}-${{github.ref}}
  cancel-in-progress: true

jobs:
  build:
    defaults:
      run:
        working-directory: .
    runs-on: 'ubuntu-latest'
    steps:
      - uses: actions/checkout@v4
      - uses: nikosportolos/dart_package@v0.2.3
        with:
          coverage: true
          codecov: true
          codecov_token: ${{ secrets.CODECOV_TOKEN }}
          publish: true
          pubdev_token: ${{ secrets.PUBDEV_TOKEN }}
```

- ### Flutter workflow

```yaml
# .github/workflows/flutter.yml
# This workflow runs on every pull-request to ensure Flutter package quality.
name: Flutter Workflow

on:
  workflow_dispatch:
  pull_request:
    types: [opened, reopened, synchronize]

concurrency:
  group: ${{github.workflow}}-${{github.ref}}
  cancel-in-progress: true

jobs:
  build:
    defaults:
      run:
        working-directory: .
    runs-on: 'ubuntu-latest'
    steps:
      - uses: actions/checkout@v4
      - uses: nikosportolos/dart_package@v0.2.3
        sdK: flutter
        flutter-sdk: 3.22.3
```

## Changelog

Check the [changelog](https://github.com/nikosportolos/dart_package/tree/main/CHANGELOG.md)
to learn what's new in **dart_package**.

## Contribution

Check the [contribution guide](https://github.com/nikosportolos/dart_package/tree/main/CONTRIBUTING.md)
if you want to help with **dart_package**.
