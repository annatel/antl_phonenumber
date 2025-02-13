VERSION 0.5

elixir-base:
    FROM --platform=$BUILDPLATFORM elixir:1.14.3-alpine
    RUN apk add --no-progress --update openssh-client git build-base unzip
    RUN mix local.rebar --force && mix local.hex --force

    RUN apk --no-cache --update add libgcc libstdc++ \
        git make g++ \
        build-base gtest gtest-dev boost boost-dev cmake protobuf protobuf-dev icu icu-dev openssl \
        && \
        rm -rf /var/cache/apk/*

    WORKDIR /tmp
    ARG TARGETOS
    ARG TARGETARCH
    RUN wget -O assets.zip https://github.com/annatel/libphonenumber/releases/download/v8.13.55-antl-0.5.4/assets_${TARGETOS}_${TARGETARCH}.zip
    WORKDIR /usr/local
    RUN unzip /tmp/assets.zip

    WORKDIR /app

deps:
    ARG MIX_ENV
    FROM +elixir-base
    ENV MIX_ENV="$MIX_ENV"
    COPY mix.exs .
    COPY mix.lock .
    RUN mix deps.get --only "$MIX_ENV"
    RUN mix deps.compile

compile-lint:
    FROM --platform=$BUILDPLATFORM earthly/dind:alpine
    WORKDIR /test

    COPY --dir lib priv test cpp_src .
    COPY Makefile .
    COPY README.md .
    COPY .formatter.exs .

    WITH DOCKER --load antl_phonenumber:latest=+deps --build-arg MIX_ENV="test"
        RUN docker run \
            --rm \
            -e MIX_ENV=test \
            -e EX_LOG_LEVEL=warn \
            -v "$PWD/lib:/app/lib" \
            -v "$PWD/priv:/app/priv" \
            -v "$PWD/cpp_src:/app/cpp_src" \
            -v "$PWD/test:/app/test" \
            -v "$PWD/Makefile:/app/Makefile" \
            -v "$PWD/README.md:/app/README.md" \
            -v "$PWD/.formatter.exs:/app/.formatter.exs" \
            -w /app \
            --name antl_phonenumber \
            antl_phonenumber:latest mix do format --check-formatted, compile --warnings-as-errors;

    END

test:
    FROM --platform=$BUILDPLATFORM earthly/dind:alpine
    WORKDIR /test

    COPY --dir lib priv test cpp_src .
    COPY Makefile .
    COPY README.md .

    WITH DOCKER --load antl_phonenumber:latest=+deps --build-arg MIX_ENV="test"
        RUN docker run \
            --rm \
            -e MIX_ENV=test \
            -e EX_LOG_LEVEL=warn \
            -v "$PWD/lib:/app/lib" \
            -v "$PWD/priv/.gitignore:/app/priv/.gitignore" \
            -v "$PWD/cpp_src:/app/cpp_src" \
            -v "$PWD/test:/app/test" \
            -v "$PWD/Makefile:/app/Makefile" \
            -v "$PWD/README.md:/app/README.md" \
            -w /app \
            --name antl_phonenumber \
            antl_phonenumber:latest mix test;

    END

check-tag:
    ARG TAG
    FROM +elixir-base
    COPY mix.exs .
    ARG APP_VERSION=$(mix app.version)
    IF [ ! -z $TAG ] && [ ! $TAG == $APP_VERSION ]
        RUN echo "TAG '$TAG' has to be equal to APP_VERSION '$APP_VERSION'" && false
    END
