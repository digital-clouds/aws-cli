# AWS CLI v2 Alpine Image

Lightweight Docker Alpine image for the AWS CLI v2.

## Docker CLI usage

The AWS CLI can be executed from the Docker CLI with the `docker run` command:

```shell
docker run -it --rm ghcr.io/digital-clouds/aws-cli --help
```

In order to run a command that makes an AWS API call, credentials and configuration may need to be shared from the host system to the container. Assuming credentials and configuration are being set in the `~/.aws/credentials` and `~/.aws/config` file on the host system, they can be shared by mounting the `~/.aws` directory to the `/root/.aws` directory of the container:

```shell
# Mount AWS credentials from the local ~/.aws directory to execute AWS CLI commands
docker run -it --rm -v ~/.aws:/root/.aws ghcr.io/digital-clouds/aws-cli <command>
```

```shell
# Mount local directory and create a new AWS profile
docker run -it --rm -v ~/.aws:/root/.aws ghcr.io/digital-clouds/aws-cli configure --profile <profile-name>
```

For some AWS CLI v2 commands, you'll want to either read files from the host system in the container or write files from the container to the host system. This can be accomplished by mounting to the container's `/aws` directory:

```shell
docker run --rm -ti -v ~/.aws:/root/.aws -v $(pwd):/aws ghcr.io/digital-clouds/aws-cli s3 cp s3://aws-cli-docker-demo/hello .
```

In order to shorten the length of `docker` commands, you can add the following alias:

```shell
# Create an alias for the Docker command to run AWS CLI commands
alias aws='docker run --rm -it ghcr.io/digital-clouds/aws-cli'
```

```shell
# Create an alias for the Docker command to mount AWS credentials and run AWS CLI commands
alias aws='docker run --rm -it -v ~/.aws:/root/.aws -v $(pwd):/aws ghcr.io/digital-clouds/aws-cli'
```

Update the AWS CLI v2 container image:

```shell
docker pull ghcr.io/digital-clouds/aws-cli
```

## General AWS CLI usage

For information on general usage of the AWS CLI, please refer to the:

- [AWS CLI user guide](https://docs.aws.amazon.com/cli/latest/userguide/cli-chap-welcome.html)
- [AWS CLI reference guide](https://docs.aws.amazon.com/cli/latest/reference/)

- [AWS CLI Source](https://github.com/aws/aws-cli)
