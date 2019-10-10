FROM ruby:2.6.5
LABEL maintainer="NAKANO Hideo <nakano@web-tips.co.jp>"

#
# Google Chrome & Fonts
#
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add -
RUN sh -c 'echo "deb [arch=amd64] http://dl.google.com/linux/chrome/deb/ stable main" > /etc/apt/sources.list.d/google.list'
RUN apt-get update && apt-get install -y google-chrome-stable
RUN apt install -y fonts-ipafont fonts-ipaexfont && fc-cache -fv

#
# Mongodb Shell & Tools
#
RUN wget -q -O - https://www.mongodb.org/static/pgp/server-3.4.asc | apt-key add -
RUN sh -c 'echo "deb [check-valid-until=no] http://archive.debian.org/debian jessie-backports main" > /etc/apt/sources.list.d/jessie-backports.list'
RUN sh -c 'echo "deb http://repo.mongodb.org/apt/debian jessie/mongodb-org/3.4 main" > /etc/apt/sources.list.d/mongodb-org-3.4.list'
RUN apt-get update
RUN apt install -y mongodb-org-shell mongodb-org-tools

# Prepare for building custom libs
RUN mkdir -p /usr/local/src

#
# Mecab & Dictionaries & Ruby Gem
#

# mecab
RUN wget -O /usr/local/src/mecab-0.996.tar.gz 'https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7cENtOXlicTFaRUE'
RUN cd /usr/local/src && tar xzf mecab-0.996.tar.gz
RUN cd /usr/local/src/mecab-0.996 && ./configure --enable-utf8-only && make && make install
RUN ldconfig

# mecab-ipadic
RUN cd /usr/local/src
RUN wget -O /usr/local/src/mecab-ipadic-2.7.0-20070801.tar.gz 'https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7MWVlSDBCSXZMTXM'
RUN wget -O /usr/local/src/mecab-ipadic-2.7.0-20070801.patch https://raw.githubusercontent.com/shirasagi/shirasagi/stable/vendor/mecab/mecab-ipadic-2.7.0-20070801.patch
RUN cd /usr/local/src && tar xzf mecab-ipadic-2.7.0-20070801.tar.gz
RUN cd /usr/local/src/mecab-ipadic-2.7.0-20070801 && patch -p1 < ../mecab-ipadic-2.7.0-20070801.patch
RUN cd /usr/local/src/mecab-ipadic-2.7.0-20070801 && ./configure --with-charset=UTF-8 && make && make install
RUN ldconfig

# mecab-ruby
RUN cd /usr/local/src
RUN wget -O /usr/local/src/mecab-ruby-0.996.tar.gz 'https://drive.google.com/uc?export=download&id=0B4y35FiV1wh7VUNlczBWVDZJbE0'
RUN cd /usr/local/src && tar xzf mecab-ruby-0.996.tar.gz
RUN cd /usr/local/src/mecab-ruby-0.996 && ruby extconf.rb && make && make install
RUN ldconfig

#
# Voice
#

# lame & sox
RUN apt install -y lame sox

# hts_engine_API
RUN wget -O /usr/local/src/hts_engine_API-1.08.tar.gz http://downloads.sourceforge.net/hts-engine/hts_engine_API-1.08.tar.gz
RUN cd /usr/local/src && tar xzf hts_engine_API-1.08.tar.gz
RUN cd /usr/local/src/hts_engine_API-1.08 && ./configure && make && make install
RUN ldconfig

# open_jtalk
RUN wget -O /usr/local/src/open_jtalk-1.07.tar.gz http://downloads.sourceforge.net/open-jtalk/open_jtalk-1.07.tar.gz
RUN cd /usr/local/src && tar xzf open_jtalk-1.07.tar.gz
RUN cd /usr/local/src/open_jtalk-1.07 && sed -i "s/#define MAXBUFLEN 1024/#define MAXBUFLEN 10240/" bin/open_jtalk.c
RUN cd /usr/local/src/open_jtalk-1.07 && sed -i "s/0x00D0 SPACE/0x000D SPACE/" mecab-naist-jdic/char.def
RUN cd /usr/local/src/open_jtalk-1.07 && ./configure --with-charset=UTF-8 && make && make install
RUN ldconfig
