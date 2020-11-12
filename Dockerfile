FROM python:3.8.2-slim

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

# install the necesarry OS applicationa
#   install LaTeX from source as the OS texlive is ridiculusly old
RUN apt-get update
RUN apt-get install -y apt-utils
RUN apt-get install -y wget
RUN apt-get -y upgrade perl
RUN apt-get -y install perl-doc
COPY texlive.profile ./
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -xzf install-tl-unx.tar.gz
RUN directory=`ls -d install-tl-2*` && echo $directory && cd $directory \
        && perl install-tl  --profile=/tmp/texlive.profile
RUN echo 'export PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH' >> .bashrc

#   install pandoc
RUN wget https://github.com/jgm/pandoc/releases/download/2.11.0.4/pandoc-2.11.0.4-1-amd64.deb
RUN dpkg -i pandoc-2.11.0.4-1-amd64.deb
RUN rm pandoc-2.11.0.4-1-amd64.deb
RUN apt-get install -y libfontconfig1

# pandoc 
RUN mkdir -p /opt/pandoc-crossref/bin
WORKDIR /opt/pandoc-crossref/bin
RUN wget https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.8.3a/pandoc-crossref-Linux.tar.xz
RUN apt-get install -y xz-utils
RUN unxz pandoc-crossref-Linux.tar.xz
RUN tar -xf pandoc-crossref-Linux.tar
RUN rm pandoc-crossref-Linux.tar
RUN echo "export PATH=/opt/pandoc-crossref/bin:$PATH" >> .bashrc
WORKDIR /tmp

# Libertinus fonts
WORKDIR /usr/share/fonts/opentype
RUN apt-get install fontconfig
RUN wget https://github.com/alerque/libertinus/releases/download/v7.020/Libertinus-7.020.zip
RUN apt-get install -y unzip
RUN unzip Libertinus-7.020.zip
RUN rm Libertinus-7.020.zip
RUN fc-cache -f -v
WORKDIR /tmp


# special package for mur2 
RUN apt-get install -y gcc 
RUN apt-get install -y fonts-noto-cjk


