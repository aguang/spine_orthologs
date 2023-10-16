FROM davidemms/orthofinder

## Perl prereqs for TransDecoder

RUN curl -L https://cpanmin.us | perl - App::cpanminus
RUN cpanm install DB_File
RUN cpanm install URI::Escape

ENV SRC /usr/local/src
ENV BIN /usr/local/bin

# copied directly from https://github.com/TransDecoder/TransDecoder/blob/master/Docker/Dockerfile
WORKDIR $SRC
ENV TRANSDECODER_CO=817d772325c8a354aec6b94ac58993b994ac7392

RUN git clone https://github.com/TransDecoder/TransDecoder.git && \
   cd TransDecoder && \
   git checkout $TRANSDECODER_CO && \
   mv * $BIN