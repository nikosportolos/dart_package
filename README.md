# Dart Package
### This is an action to validate and publish a Dart package to pub.dev.

## Usage


## Setup


## Examples

### Pull-request workflow:
```yaml
# .github/workflows/pr.yml 
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
    uses: nikosportolos/dart-package@v1
    with:
      coverage: false
```


### Merge workflow:

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