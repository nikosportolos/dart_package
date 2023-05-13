# Dart Package

#### This is a GitHub Action to validate and publish a Dart package to [pub.dev](https://pub.dev/).

## Table of contents

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

Specify the directories where dart analyze will run.

|Required| Default    |
|--------|------------|
|false   | "lib test" |

  
- ### line_length

The line length to use with dart format.

|Required| Default |
|--------|---------|
|false   | "120"   |

  
- ### concurrency

Controls the number of test suites that runs concurrently, 
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

Flag that defines whether to run tests with coverage.

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

Flag that defines whether to publish the Dart package on pub.dev. 

|Required| Default |
|--------|---------|
|false   | "false" |


- ### pubdev_token

The token that will be used to publish the Dart package to pub.dev. 

|Required| Default |
|--------|---------|
|false   | ""      |

   
- ### pana_threshold

The exit code will indicate if (max - granted points) <= threshold. 

|Required| Default |
|--------|---------|
|false   | "19"    |


## Examples

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
    uses: nikosportolos/dart-package@v1
    with:
      coverage: false
```


- ### Merge workflow

```yaml
# .github/workflows/merge.yml 
name: Merge Workflow
description: This workflow runs when merging a PR to the main branch.

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
    uses: nikosportolos/dart-package@v1
    with:
      coverage: true
      codecov: true
      codecov_token: ${{ secrets.CODECOV_TOKEN }}
```


- ### Publish workflow

```yaml
# .github/workflows/publish.yml 
name: Publish Workflow
description: This workflow runs when publishing a Dart package to pub.dev.

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
    uses: nikosportolos/dart-package@v1
    with:
      coverage: true
      codecov: true
      codecov_token: ${{ secrets.CODECOV_TOKEN }}
      publish: true
      pubdev_token: ${{ secrets.PUBDEV_TOKEN }}
```
