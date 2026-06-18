FROM docker.io/kicad/kicad:10.0.2
ARG IBOM_VERSION="2.11.1"
ARG KIKIT_VERSION="1.8.0"

# KiCad image leaves us with user 'kicad' set
USER root

RUN apt-get update && apt-get -y install csvkit qpdf unzip zip curl git && rm -rf /var/cache/apt/archives /var/lib/apt/lists
RUN apt-get update && apt-get -y install pandoc texlive-latex-base texlive-fonts-recommended texlive-latex-recommended texlive-xetex lmodern fonts-open-sans fonts-roboto fonts-liberation && rm -rf /var/cache/apt/archives /var/lib/apt/lists
RUN apt-get update && apt-get -y install pipx && rm -rf /var/cache/apt/archives /var/lib/apt/lists

RUN curl -L https://github.com/openscopeproject/InteractiveHtmlBom/archive/refs/tags/v${IBOM_VERSION}.zip -o /ibom.zip && \
    unzip -d /opt /ibom.zip && rm /ibom.zip && \
    ln -s /opt/InteractiveHtmlBom-${IBOM_VERSION}/InteractiveHtmlBom/generate_interactive_bom.py /usr/local/bin/

USER kicad
ENV INTERACTIVE_HTML_BOM_NO_DISPLAY=y
ENV PATH=/home/kicad/.local/bin:$PATH
RUN pipx install --system-site-packages kikit==${KIKIT_VERSION}

# Allow git commands to be run even if the user does not own the directory
RUN git config --global --add safe.directory "*"

COPY assembly-drawing-theme.json /home/kicad/.config/kicad/10.0/colors/assembly-drawing-theme.json
