#!/usr/bin/env bash

CURDIR=$(cd $(dirname $0); pwd)
GATEPATH="${CURDIR}/gateway"
MICROPATH="${CURDIR}/micro"
GENPATH="${CURDIR}/gen"
TPLPATH="${CURDIR}/tpl"
MICROTPLPATH="${TPLPATH}/kitex/server"
GATETPLPATH="${TPLPATH}/hertz/server"
IDLPATH="${CURDIR}/idl"
TMPFPATH="${CURDIR}/wheelergeo"
TMPPATH="${TMPFPATH}/g-otter-gen"
GATEMODULE="github.com/wheelergeo/g-otter-gateway"
MICROMODULE="github.com/wheelergeo/g-otter-micro"
GENMODULE="github.com/wheelergeo/g-otter-gen"

if [ ! -d $GENPATH ]; then
    echo "Error: gen dir is not existed!"
    exit 1
fi

while getopts ":gm:a:ud:h" opt
do
    case $opt in
        h) #help
            echo "-g create gateway"
            echo "-m create micro server"
            echo "-a update micro server"
            echo "-u update gateway"
            echo "-d delete micro server"
            ;;
        g) # create gateway
            if [ ! -d $GATEPATH ]; then
                mkdir $GATEPATH
            fi
            cd $GATEPATH
            hz new -idl ${IDLPATH}/gateway.thrift \
                   -module ${GATEMODULE} \
                   --customize_layout           ${GATETPLPATH}/layout.yaml  \
                   --customize_layout_data_path ${GATETPLPATH}/data.json    \
                   --customize_package          ${GATETPLPATH}/package.yaml
            go mod tidy
            ;;
        m) # create micro
            if [ ! -d $MICROPATH ]; then
                mkdir $MICROPATH
            fi
            MICRO=$OPTARG
            MICROMODULE=${MICROMODULE}-${MICRO}

            if [ ! -d $MICROPATH/${MICRO} ]; then
                mkdir ${MICROPATH}/${MICRO}
            fi
            cd ${MICROPATH}/${MICRO}

            if [ ! -f $MICROPATH/${MICRO}/go.mod ]; then
                go mod init ${MICROMODULE}
            fi

            mkdir -p ${TMPPATH}
            kitex -module ${MICROMODULE} \
                  -gen-path ../../wheelergeo/g-otter-gen \
                  ${IDLPATH}/${MICRO}.thrift

            if [ -d ${GENPATH}/${MICRO} ]; then
                rm -rf ${GENPATH}/${MICRO}
            fi
            mv ${TMPPATH}/${MICRO} ${GENPATH}/${MICRO}
            rm -rf ${TMPFPATH}

            cwgo server -service ${MICRO} \
                  -module ${MICROMODULE} \
                  -type RPC \
                  -pass "-use ${GENMODULE}" \
                  -template ${MICROTPLPATH} \
                  -idl ${IDLPATH}/${MICRO}.thrift
            go mod edit -replace=${GENMODULE}=../../gen
            go mod tidy
            ;;
        a) # update micro gen
            MICRO=$OPTARG
            MICROMODULE=${MICROMODULE}-${MICRO}

            if [ ! -d ${MICROPATH}/${MICRO} ]; then
                echo "Error: micro dir is not existed!"
                exit 1
            fi

            cd ${MICROPATH}/${MICRO}

            mkdir -p ${TMPPATH}
            kitex -module ${MICROMODULE} \
                  -gen-path ../../wheelergeo/g-otter-gen \
                  ${IDLPATH}/${MICRO}.thrift

            if [ -d ${GENPATH}/${MICRO} ]; then
                rm -rf ${GENPATH}/${MICRO}
            fi
            mv ${TMPPATH}/${MICRO} ${GENPATH}/${MICRO}
            rm -rf ${TMPFPATH}

            kitex -module ${MICROMODULE} \
                  -use ${GENMODULE} \
                  -template-dir ${MICROTPLPATH} \
                  ${IDLPATH}/${MICRO}.thrift
            ;;
        u) # update gateway
            if [ ! -d $GATEPATH ]; then
                echo "Error: gateway dir is not existed!"
                exit 1
            fi
            cd $GATEPATH
            hz update -idl ${IDLPATH}/gateway.thrift \
                      -module             ${GATEMODULE} \
                      --customize_package ${GATETPLPATH}/package.yaml
            go mod tidy
            ;;
        d) # delete micro
            MICRO=$OPTARG

            if [ -d ${MICROPATH}/${MICRO} ]; then
                rm -rf ${MICROPATH}/${MICRO}
            fi

            if [ -d ${GENPATH}/${MICRO} ]; then
                rm -rf ${GENPATH}/${MICRO}
            fi
            ;;
        ?)
            echo "there is unrecognized parameter."
            exit 1
            ;;
    esac
done

