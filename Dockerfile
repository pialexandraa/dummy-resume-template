FROM debian:bookworm-slim

ENV DEBIAN_FRONTEND=noninteractive

# Install minimal TeX Live engine, required fonts, and Poppler utilities (for image rendering)
RUN apt-get update && apt-get install -y --no-install-recommends \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    poppler-utils \
    make \
    && rm -rf /var/lib/apt/lists/*

WORKDIR /workspace

CMD ["pdflatex", "-interaction=nonstopmode", "main.tex"]