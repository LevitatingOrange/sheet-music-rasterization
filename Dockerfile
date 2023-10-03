FROM debian:bookworm-slim

ARG USER
ARG UID

RUN apt update && apt install -y poppler-utils rustc cargo cairosvg ghostscript

RUN useradd -m -u ${UID} -s /bin/bash ${USER}
USER ${USER}

RUN cargo install vtracer
RUN echo "export PATH=\$PATH:/home/${USER}/.cargo/bin" >> /home/${USER}/.bashrc

USER root
COPY ./rasterize_pdf.sh /usr/local/bin/rasterize_pdf
COPY ./rasterize_all.sh /usr/local/bin/rasterize_all

USER ${USER}
WORKDIR /home/${USER}/docs

ENV PATH=$PATH:/home/${USER}/.cargo/bin
CMD ["bash", "-c", "rasterize_all"]
