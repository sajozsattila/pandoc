FROM python:3.8.2-slim

ARG DEBIAN_FRONTEND=noninteractive

WORKDIR /tmp

# install the necesarry OS applicationa
#   install LaTeX from source as the OS texlive is ridiculusly old
RUN apt-get update -y &&  apt-get install -y apt-utils wget &&  apt-get -y upgrade perl &&  apt-get install -y perl-doc 
COPY texlive.profile ./ 
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz && tar -xzf install-tl-unx.tar.gz 
RUN directory=`ls -d install-tl-2*` && echo $directory && cd $directory \
        && perl install-tl  --profile=/tmp/texlive.profile
RUN echo 'export PATH=/usr/local/texlive/2021/bin/x86_64-linux:$PATH' >> /root/.bashrc

#   install pandoc
RUN wget https://github.com/jgm/pandoc/releases/download/2.13/pandoc-2.13-1-amd64.deb && dpkg -i pandoc-2.13-1-amd64.deb &&  rm pandoc-2.13-1-amd64.deb  && apt-get install -y libfontconfig1

# pandoc 
RUN mkdir -p /opt/pandoc-crossref/bin
WORKDIR /opt/pandoc-crossref/bin
RUN wget https://github.com/lierdakil/pandoc-crossref/releases/download/v0.3.10.0a/pandoc-crossref-Linux.tar.xz && apt-get install -y xz-utils && unxz pandoc-crossref-Linux.tar.xz && tar -xf pandoc-crossref-Linux.tar &&  rm pandoc-crossref-Linux.tar &&  echo "export PATH=/opt/pandoc-crossref/bin:$PATH" >> /root/.bashrc
WORKDIR /tmp

# Libertinus fonts
WORKDIR /usr/share/fonts/opentype
RUN apt-get install fontconfig &&  wget https://github.com/alerque/libertinus/releases/download/v7.040/Libertinus-7.040.zip&&  apt-get install -y unzip &&  unzip Libertinus-7.040.zip && rm Libertinus-7.040.zip && fc-cache -f -v
WORKDIR /tmp


# special package for mur2 
RUN apt-get install -y gcc fonts-noto-cjk

