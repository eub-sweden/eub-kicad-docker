FROM docker.io/kicad/kicad:8.0.4
ARG IBOM_VERSION="v2.9.0"

# KiCad image leaves us with user 'kicad' set
USER root

RUN apt-get update && apt-get -y install unzip zip curl git && rm -rf /var/cache/apt/archives /var/lib/apt/lists

RUN curl -L https://github.com/openscopeproject/InteractiveHtmlBom/archive/refs/tags/${IBOM_VERSION}.zip -o /ibom.zip && \
    unzip -d /opt /ibom.zip && rm /ibom.zip && \
    ln -s /opt/InteractiveHtmlBom-2.9.0/InteractiveHtmlBom/generate_interactive_bom.py /usr/local/bin/
ENV INTERACTIVE_HTML_BOM_NO_DISPLAY=y

USER kicad
