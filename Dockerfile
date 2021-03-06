FROM rust

RUN apt-get update && \
    apt-get install -y cmake && \
    rm -rf /var/lib/apt/lists/*

WORKDIR /opt/tarpaulin

RUN env USER=root cargo init .

COPY Cargo.toml .
COPY Cargo.lock .
RUN mkdir .cargo
RUN cargo vendor > .cargo/config

COPY . /opt/tarpaulin/

RUN cd /opt/tarpaulin/ && \
    cargo install --locked --path . && \
    rm -rf /opt/tarpaulin/ && \
    rm -rf /usr/local/cargo/registry/

WORKDIR /volume

CMD cargo build && cargo tarpaulin
