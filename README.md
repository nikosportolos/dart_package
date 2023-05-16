# Dart Package

#### This is a GitHub Action to validate and publish a Dart package to [pub.dev](https://pub.dev/).

## Table of contents

- [Setup](#setup)
  - [Setting up secrets in GitHub](#setting-up-secrets)
  - [Codecov](#codecov)
  - [Pub.dev](#pubdev)
- [Inputs](#inputs)
  - [working_directory](#working-directory)
  - [dart_sdk](#dart-sdk)
  - [analyze_directories](#analyze_directories)
  - [line_length](#line_length)
  - [concurrency](#concurrency)
  - [skip_tests](#skip_tests)
  - [coverage](#coverage)
  - [codecov](#codecov)
  - [codecov_token](#codecov_token)
  - [publish](#publish)
  - [pubdev_token](#pubdev_token)
  - [pana_threshold](#pana_threshold)
- [Examples](#examples)
  - [Pull-request workflow](#pull-request-workflow)
  - [Merge workflow](#merge-workflow)
  - [Publish workflow](#publish-workflow)


## Setup

### Setting up secrets in GitHub

In order to upload Coverage reports to Codecov or/and to publish a dart package on [pub.dev](https://pub.dev) 
we need to set up the corresponding tokens as secrets in our GitHub repository.

You can find [here](https://docs.github.com/en/codespaces/managing-codespaces-for-your-organization/managing-encrypted-secrets-for-your-repository-and-organization-for-github-codespaces) 
more information about secrets & environment variables.

Your secrets in your GitHub repository should look that:

<a href="https://github.com/nikosportolos/dart_package/blob/main/assets/images/github_secret.png" target="_blank">
  <img src="https://github.com/nikosportolos/dart_package/blob/main/assets/images/github_secret.png" width="80%" alt="github-secrets">
</a>


- #### Codecov

The unique repository upload token is found on the settings page of your project. 
You need write access to view this token.

For GitHub repositories the token will be found in `https://codecov.io/github/<owner>/<repo>/settings`.

<a href="https://github.com/nikosportolos/dart_package/blob/main/assets/images/codecov_token.png" target="_blank">
  <img src="https://github.com/nikosportolos/dart_package/blob/main/assets/images/codecov_token.png" width="80%" alt="codecov-token">
</a>


- #### Pub.dev

You can aquire your `pub-credentials.json` simply by running the command `dart pub login` and logging in to pub.dev 
with your Gmail account via a browser.

The `pub-credentials.json` will be generated in the default dart config folder in your system.

You can find it depending on your OS in the following directories:

- On Linux *(see XDG specification)*
  - If `$XDG_CONFIG_HOME` is defined:
    - `$XDG_CONFIG_HOME/dart/pub-credentials.json`
  - else
    - `$HOME/.config/dart/pub-credentials.json`

- On Mac OS *(see [developer.apple.com](https://developer.apple.com))*
   - `~/Library/Application Support/dart/pub-credentials.json`

- On Windows *(or maybe `%LOCALAPPDATA%` is better)*
   - `%APPDATA%/dart/pub-credentials.json`

Read more: https://github.com/dart-lang/pub/issues/2999#issuecomment-908350917


## Inputs

- ### working_directory

Specify the working directory where the workflow will run.

|Required|Default|
|--------|-------|
|false   | "."   |


- ### dart_sdk

Specify the Dart SDK version that will be used.

|Required| Default  |
|--------|----------|
|false   | "2.19.6" |


- ### analyze_directories

Specify the directories where [dart analyze](https://dart.dev/tools/dart-analyze) will run.

|Required| Default    |
|--------|------------|
|false   | "lib test" |

  
- ### line_length

The line length to use with [dart format](https://dart.dev/tools/dart-format).

|Required| Default |
|--------|---------|
|false   | "120"   |

  
- ### concurrency

Controls the number of test suites that runs [concurrently](https://pub.dev/packages/test#test-concurrency), 
meaning that multiple tests in independent suites or platforms can run at the same time.

|Required| Default |
|--------|---------|
|false   | "4"     |

  
- ### skip_tests

Flag that defines whether to skip tests.

|Required| Default |
|--------|---------|
|false   | "false" |

  
- ### coverage

Flag that defines whether to run tests with [coverage](https://pub.dev/packages/test#collecting-code-coverage).

|Required| Default |
|--------|---------|
|false   | "false" |

 
- ### codecov

Flag that defines whether to upload coverage reports to [Codecov](https://about.codecov.io/). 

Requires the [codecov_token](#codecov_token).

|Required| Default |
|--------|---------|
|false   | "false" |

  
- ### codecov_token

The token that will be used to upload coverage reports to [Codecov](https://about.codecov.io/). 

Requires the [codecov](#codecov) flag to be set to true. 

|Required| Default |
|--------|---------|
|false   | ""      |

   
- ### publish

Flag that defines whether to publish the Dart package on [pub.dev](https://pub.dev/). 

|Required| Default |
|--------|---------|
|false   | "false" |


- ### pubdev_token

The token that will be used to publish the Dart package to [pub.dev](https://pub.dev/). 

|Required| Default |
|--------|---------|
|false   | ""      |

   
- ### pana_threshold

Set a threshold in [pana](https://pub.dev/packages/pana)'s analysis report. The exit code will indicate if (max - granted points) <= threshold. 

|Required| Default |
|--------|---------|
|false   | "19"    |


## Examples

You can try the **data_package** GitHub Action using the workflows in the [examples](https://github.com/nikosportolos/data_package/tree/main/examples/workflows) folder.

- ### Pull-request workflow

```yaml
# .github/workflows/pr.yml 
name: PR Workflow
description: This workflow runs on every pull-request to ensure dart package quality.

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
    runs-on: "ubuntu-latest"
    steps:
      - name: 📚 Git Checkout
        uses: actions/checkout@v3

      - name: dart-package
        uses: nikosportolos/dart_package@v0.0.1
```


- ### Merge workflow

```yaml
# .github/workflows/merge.yml 
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
    runs-on: "ubuntu-latest"
    steps:
      - name: 📚 Git Checkout
        uses: actions/checkout@v3

      - name: dart-package
        uses: nikosportolos/dart_package@v0.0.1
        with:
          coverage: true
          codecov: true
          codecov_token: ${{ secrets.CODECOV_TOKEN }}
```


- ### Publish workflow

```yaml
# .github/workflows/publish.yml 
name: Publish Workflow
description: This workflow runs when publishing a Dart package on pub.dev.

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
    runs-on: "ubuntu-latest"
    steps:
      - name: 📚 Git Checkout
        uses: actions/checkout@v3

      - name: dart-package
        uses: nikosportolos/dart_package@v0.0.1
        with:
          coverage: true
          codecov: true
          codecov_token: ${{ secrets.CODECOV_TOKEN }}
          publish: true
          pubdev_token: ${{ secrets.PUBDEV_TOKEN }}
```
