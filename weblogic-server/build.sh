#!/bin/sh

tag_name() {
   tagName=${CUSTOM_IMAGE_TAG:-"weblogic:latest"}
   echo "CUSTOM_IMAGE_TAG  ${tagName} "
}

# The location where the script is running will be used as the Context for
# the docker build Dockerfile commands
set_context() {
   scriptDir="$( cd "$( dirname "$0" )" && pwd )"
   if [ ! -d "${scriptDir}" ]; then
       echo "Unable to determine the working directory for the domain home in image sample"
       echo "Using shell /bin/sh to determine and found ${scriptDir}"
       clean_and_exit
   fi
   echo "Context for docker build is ${scriptDir}"
}

set_context
./${scriptDir}/container-scripts/setEnv.sh ${scriptDir}/properties/docker-build/domain.properties

tag_name

cat ${scriptDir}/properties/docker-build/domain_security.properties > /tmp/ds.prop
podman build --force-rm=true --no-cache=true $BUILD_ARG -t  ${tagName}  ${scriptDir}
