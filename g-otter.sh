#!/usr/bin/env bash

CURDIR=$(cd $(dirname $0); pwd)
GATEPATH="${CURDIR}/gateway"
MICROPATH="${CURDIR}/micro"
IDLPATH="${CURDIR}/otter_gen/idl"
OTTERGENPATH="${CURDIR}/otter_gen"
GATEMODULE="github.com/wheelergeo/g-otter/gateway"
MICROMODULE="github.com/wheelergeo/g-otter/micro"
OTTERGENMODULE="github.com/wheelergeo/g-otter/otter_gen"


while getopts ":gm:" opt
do
    case $opt in
        g)
            if [ ! -d $GATEPATH ]; then
              mkdir $GATEPATH
            fi
            cd $GATEPATH
            hz new -idl ${IDLPATH}/gateway.thrift -module ${GATEMODULE}
            mkdir ${GATEPATH}/main
            mv    ${GATEPATH}/main.go ${GATEPATH}/main
            sed -i "s/register/cmd.Register/g" ${GATEPATH}/main/main.go
            sed -i "s/main/cmd/g" ${GATEPATH}/router.go
            sed -i "s/main/cmd/g" ${GATEPATH}/router_gen.go
            sed -i "s/register/Register/g" ${GATEPATH}/router_gen.go
            go mod tidy
            ;;
        m)
            if [ ! -d $MICROPATH ]; then
              mkdir $MICROPATH
            fi
            MICRO=$OPTARG
            MICROMODULE=${MICROMODULE}/${MICRO}
            mkdir ${MICROPATH}/${MICRO}
            cd ${MICROPATH}/${MICRO}
            go mod init ${MICROMODULE}
            kitex -module ${MICROMODULE} -service ${MICRO} -gen-path ../../otter_gen ${IDLPATH}/${MICRO}.thrift
            go mod edit -replace=${OTTERGENMODULE}=${OTTERGENPATH}
            go mod tidy
            ;;
        ?)
            echo "there is unrecognized parameter."
            exit 1
            ;;
    esac
done

