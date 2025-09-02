FROM docker.io/kicad/kicad:9.0.3
ARG IBOM_VERSION="2.9.0"
ARG KIBOM_VERSION="1.9.1"

# KiCad image leaves us with user 'kicad' set
USER root

RUN apt-get update && apt-get -y install csvkit qpdf unzip zip curl git && rm -rf /var/cache/apt/archives /var/lib/apt/lists

RUN curl -L https://github.com/openscopeproject/InteractiveHtmlBom/archive/refs/tags/v${IBOM_VERSION}.zip -o /ibom.zip && \
    unzip -d /opt /ibom.zip && rm /ibom.zip && \
    ln -s /opt/InteractiveHtmlBom-${IBOM_VERSION}/InteractiveHtmlBom/generate_interactive_bom.py /usr/local/bin/
ENV INTERACTIVE_HTML_BOM_NO_DISPLAY=y

RUN curl -L https://github.com/SchrodingersGat/kibom/archive/refs/tags/${KIBOM_VERSION}.zip -o /kibom.zip && \
    unzip -d /opt /kibom.zip && rm /kibom.zip && \
    ln -s /opt/KiBoM-${KIBOM_VERSION}/KiBOM_CLI.py /usr/local/bin/

USER kicad

# Allow git commands to be run even if the user does not own the directory
RUN git config --global --add safe.directory "*"

COPY assembly-drawing-theme.json /home/kicad/.config/kicad/9.0/colors/assembly-drawing-theme.json
