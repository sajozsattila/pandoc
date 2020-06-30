FROM python:3.6-slim

# the user which run the application
RUN useradd  mur2

# user home dir
WORKDIR /home/mur2

# install the necesarry OS applicationa
#   install LaTeX from source as the OS texlive is ridiculusly old
RUN apt-get update
RUN apt-get install -y wget
RUN apt-get -y upgrade perl
RUN apt-get -y install perl-doc
COPY texlive.profile ./
RUN wget http://mirror.ctan.org/systems/texlive/tlnet/install-tl-unx.tar.gz
RUN tar -xzf install-tl-unx.tar.gz
RUN directory=`ls -d install-tl-2*` && echo $directory && cd $directory \
        && perl install-tl  --profile=/home/mur2/texlive.profile
RUN echo 'export PATH=/usr/local/texlive/2020/bin/x86_64-linux:$PATH' >> .bashrc

#   install pandoc
RUN wget https://github.com/jgm/pandoc/releases/download/2.9.2.1/pandoc-2.9.2.1-1-amd64.deb
RUN dpkg -i pandoc-2.9.2.1-1-amd64.deb
RUN rm pandoc-2.9.2.1-1-amd64.deb
RUN apt-get install -y libfontconfig1

# special package for mur2 
RUN apt-get install -y gcc 
RUN apt-get install -y fonts-noto-cjk


