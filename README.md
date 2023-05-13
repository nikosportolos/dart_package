# Dart Package

#### This is an action to validate and publish a Dart package to pub.dev.

## Inputs

```yaml
working_directory:
  description: "Specify the working directory."
  required: false
  default: "."

dart_sdk:
  description: "Specify the Dart SDK version."
  required: false
  default: "2.19.6"

analyze_directories:
  description: "Specify the directories to run dart analyze."
  required: false
  default: "lib test"

line_length:
  description: "The line length to use with dart format."
  required: false
  default: "120"

concurrency:
  description: "Controls the number of test suites that runs concurrently, meaning that multiple tests in independent suites or platforms can run at the same time."
  required: false
  default: "4"

skip_tests:
  description: "Flag that defines whether to skip tests."
  required: false
  default: "false"

coverage:
  description: "Flag that defines whether to run tests with coverage."
  required: false
  default: "false"

codecov:
  description: "Flag that defines whether to upload coverage reports to Codecov. Requires the codecov_token."
  required: false
  default: "false"

codecov_token:
  description: "The token that will be used to upload coverage reports to Codecov. Requires the codecov flag to be set to true."
  required: false
  default: ""

publish:
  description: "Flag that defines whether to publish the Dart package on pub.dev."
  required: false
  default: "false"

pubdev_token:
  description: "The token that will be used to publish the dart package to pub.dev."
  required: false
  default: ""
  
pana_threshold:
  description: "The exit code will indicate if (max - granted points) <= threshold."
  required: false
  default: "19"
```

## Examples

### Pull-request workflow:

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


### Merge workflow:

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


### Publish workflow:

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
