#!/usr/bin/env bash

# for Click library to work in satosa-saml-metadata
if [[ -z "$LC_ALL" ]]; then
    export LC_ALL=C.UTF-8
fi
if [[ -z "$LANG" ]]; then
    export LANG=C.UTF-8
fi
# exit immediately on failure
set -e

if [ -z "${DATA_DIR}" ]; then
   DATA_DIR=$PWD
fi

if [ -z "${PROXY_PORT}" ]; then
   PROXY_PORT="8000"
fi

if [ -z "${METADATA_DIR}" ]; then
   METADATA_DIR="${DATA_DIR}/metadata"
fi

cd ${DATA_DIR}

mkdir -p ${METADATA_DIR}

if [ ! -d ${DATA_DIR}/attributemaps ]; then
   cp -pr /opt/satosa/attributemaps ${DATA_DIR}/attributemaps
fi

# generate metadata for front- (IdP) and back-end (SP) and write it to mounted volume

satosa-saml-metadata proxy_conf.yaml ${DATA_DIR}/metadata.key ${DATA_DIR}/metadata.crt --dir ${METADATA_DIR}

# start the proxy
#exec gunicorn $conf_opt -b0.0.0.0:${PROXY_PORT} satosa.wsgi:app
