ARG DEBIAN_TAG

FROM debian:${DEBIAN_TAG}

RUN apt-get update \ 
    && apt-get install -y --no-install-recommends bash curl coreutils ca-certificates libxi6 \
    libxtst6 libxrender1 libfreetype6 fontconfig fonts-urw-base35 \ 
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/*

ARG JDK_PKG
ARG JDK_HOME

RUN set -eux; \
      JAVA_SHA256=$(curl "$JDK_PKG".sha256) ; \
      curl --output /tmp/jdk.tgz "$JDK_PKG" \
      && echo "$JAVA_SHA256 */tmp/jdk.tgz" | sha256sum -c; \
      mkdir -p "$JDK_HOME"; \
      tar --extract --file /tmp/jdk.tgz --directory "$JDK_HOME" --strip-components 1 \
      && update-alternatives --install "/usr/bin/java" "java" "${JDK_HOME}/bin/java" 1 \
      && rm /tmp/jdk.tgz

ARG GROIMP_PKG
ARG GROIMP_VERSION
ARG GROIMP_DIR 

RUN curl --output /tmp/groimp.deb "$GROIMP_PKG" \
    && dpkg -i /tmp/groimp.deb \
    && rm /tmp/groimp.deb

COPY templates/ext/ext_linux "${GROIMP_DIR}/ext"

COPY src /var/model/src

COPY inputs /var/model/inputs

COPY scenarios /var/model/scenarios

COPY outputs /var/model/outputs

ARG MODEL_NAME

WORKDIR /var/model

CMD java "-Xmx1500M" -jar "/usr/share/GroIMP/core.jar"
