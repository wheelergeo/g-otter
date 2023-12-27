#!/usr/bin/env bash

CURDIR=$(cd $(dirname $0); pwd)
GATEPATH="${CURDIR}/gateway"
MICROPATH="${CURDIR}/micro"
GENPATH="${CURDIR}/gen"
IDLPATH="${GENPATH}/idl"
TMPPATH="${CURDIR}/wheelergeo/g-otter-gen"
GATEMODULE="github.com/wheelergeo/g-otter-gateway"
MICROMODULE="github.com/wheelergeo/g-otter-micro"
GENMODULE="github.com/wheelergeo/g-otter-gen"


while getopts ":gm:a:" opt
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
        a)
            if [ ! -d $GENPATH ]; then
                echo "Error: gen dir is not existed!"
                exit 1
            fi
            MICRO=$OPTARG
            MICROMODULE=${MICROMODULE}-${MICRO}

            if [ ! -d ${MICROPATH}/${MICRO} ]; then
                echo "Error: micro dir is not existed!"
                exit 1
            fi

            cd ${MICROPATH}/${MICRO}

            mkdir -p ${TMPPATH}
            kitex -module ${MICROMODULE} -gen-path ../../wheelergeo/g-otter-gen ${IDLPATH}/${MICRO}.thrift

            if [ -d ${GENPATH}/${MICRO} ]; then
                rm -rf ${GENPATH}/${MICRO}
            fi
            mv ../../wheelergeo/g-otter-gen/${MICRO} ../../gen/${MICRO}
            rm -rf ../../wheelergeo
            ;;
        ?)
            echo "there is unrecognized parameter."
            exit 1
            ;;
    esac
done

