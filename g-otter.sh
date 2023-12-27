#!/usr/bin/env bash

CURDIR=$(cd $(dirname $0); pwd)
GATEPATH="${CURDIR}/gateway"
MICROPATH="${CURDIR}/micro"
IDLPATH="${CURDIR}/gen/idl"
TMPPATH="${CURDIR}/wheelergeo/g-otter-gen"
GATEMODULE="github.com/wheelergeo/g-otter-gateway"
MICROMODULE="github.com/wheelergeo/g-otter-micro"
GENMODULE="github.com/wheelergeo/g-otter-gen"


while getopts ":gm:" opt
do
    case $opt in
        g)
            if [ ! -d $GATEPATH ]; then
              mkdir $GATEPATH
            fi
            cd $GATEPATH
            hz new -idl ${IDLPATH}/gateway.thrift -module ${GATEMODULE}
            go mod tidy
            ;;
        m)
            if [ ! -d $MICROPATH ]; then
              mkdir $MICROPATH
            fi
            MICRO=$OPTARG
            MICROMODULE=${MICROMODULE}-${MICRO}

            mkdir ${MICROPATH}/${MICRO}
            cd ${MICROPATH}/${MICRO}
            go mod init ${MICROMODULE}

            mkdir -p ${TMPPATH}
            kitex -module ${MICROMODULE} -gen-path ../../wheelergeo/g-otter-gen ${IDLPATH}/${MICRO}.thrift
            mv ../../wheelergeo/g-otter-gen/${MICRO} ../../gen/${MICRO}
            rm -rf ../../wheelergeo

            kitex -module ${MICROMODULE} -service ${MICRO} -use ${GENMODULE} ${IDLPATH}/${MICRO}.thrift
            go mod edit -replace=${GENMODULE}=../../gen
            go mod tidy
            ;;
        ?)
            echo "there is unrecognized parameter."
            exit 1
            ;;
    esac
done

