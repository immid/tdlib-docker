FROM alpine:3.9 as builder

RUN apk add --no-cache \
    gperf \
    alpine-sdk \
    linux-headers \
    openssl-dev \
    git \
    cmake \
    zlib-dev

WORKDIR /tmp/_build_tdlib/

RUN git clone https://github.com/tdlib/td.git /tmp/_build_tdlib/;

RUN mkdir build
WORKDIR /tmp/_build_tdlib/build/

RUN cmake -DCMAKE_BUILD_TYPE=Release ..
RUN cmake --build .
RUN make install


FROM alpine:3.9

COPY --from=builder /usr/local/lib/libtd* /usr/local/lib/
COPY --from=builder /usr/local/include/td /usr/local/include/td

RUN apk add --no-cache \
    openssl-dev \
    git \
    cmake \
    zlib-dev
