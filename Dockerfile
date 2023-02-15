ARG ALPINE_VERSION=3.17

FROM python:3.11.1-alpine${ALPINE_VERSION} as builder

ARG AWS_CLI_VERSION=2.9.23

# install dependencies
# hadolint ignore=DL3018
RUN apk add --no-cache git unzip groff build-base libffi-dev cmake \
  && git clone --single-branch --depth 1 -b ${AWS_CLI_VERSION} https://github.com/aws/aws-cli.git /aws-cli

# build aws-cli
WORKDIR /aws-cli

RUN sed -i 's/PyInstaller.*/PyInstaller==5.7.0/g' requirements-build.txt \
  && python -m venv venv \
  && . venv/bin/activate \
  && scripts/installers/make-exe \
  && unzip -q dist/awscli-exe.zip \
  && aws/install --bin-dir /aws-cli-bin \
  && /aws-cli-bin/aws --version \
  && rm -rf \
    /usr/local/aws-cli/v2/current/dist/aws_completer \
    /usr/local/aws-cli/v2/current/dist/awscli/data/ac.index \
    /usr/local/aws-cli/v2/current/dist/awscli/examples \
  && find /usr/local/aws-cli/v2/current/dist/awscli/data -name 'completions-1*.json' -delete \
  && find /usr/local/aws-cli/v2/current/dist/awscli/botocore/data -name examples-1.json -delete

# build the final image
FROM alpine:${ALPINE_VERSION}
COPY --from=builder /usr/local/aws-cli/ /usr/local/aws-cli/
COPY --from=builder /aws-cli-bin/ /usr/local/bin/

WORKDIR /aws
ENTRYPOINT ["/usr/local/bin/aws"]
