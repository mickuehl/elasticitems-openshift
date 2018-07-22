FROM centos:centos7
MAINTAINER Michael Kuehl <hello@ratchet.cc>

# Image version
ENV VERSION 1.0
ENV RELEASE 1

# Packages to install
ENV INSTALL_PKGS "curl tar unzip bc which lsof make nss_wrapper bind-utils"
ENV MONGODB_PACKAGES "mongodb-org-tools"

# Image metadata
ENV NAME="mongodb-loader"
ENV MAINTAINER="hello@ratchet.cc"
ENV VENDOR="Elasticitems"
ENV SUMMARY="Base image for loading data into MongoDB"
ENV DESCRIPTION="Base image for loading data into MongoDB"
ENV TAGS="builder,s2i,mongodb"

# Locations, $PATH etc.
ENV STI_SCRIPTS_PATH=/usr/local/sti
ENV APP_ROOT=/opt/app-root

# User ID 
ENV USER_ID 10001

### Atomic/OpenShift Labels - https://github.com/projectatomic/ContainerApplicationGenericLabels
LABEL name="$NAME" \
      maintainer="$MAINTAINER" \
      vendor="$VENDOR" \
      version="$VERSION" \
      release="$RELEASE" \
      summary="$SUMMARY" \
      description="$DESCRIPTION" \
      io.k8s.description="DESCRIPTION" \
      io.k8s.display-name="$NAME" \
      io.openshift.tags="$TAGS"

# Install basic components

# Gain access to EPEL (Extra Packages for Enterprise Linux)
RUN yum install -y epel-release

# Install the MongoDB repo
COPY mongodb-org.repo /etc/yum.repos.d/mongodb-org.repo

# Clean the cache (see https://access.redhat.com/articles/1320623)
RUN rm -fr /var/cache/yum/* && yum clean all 

# Install OS packages
RUN yum install -y --enablerepo=centosplus $INSTALL_PKGS $MONGODB_PACKAGES && \
    rpm -V $INSTALL_PKGS $MONGODB_PACKAGES && \
    yum clean all && \
    rm -rf /var/cache/yum

# Install S2I scripts etc.
LABEL io.openshift.s2i.scripts-url=image:///usr/local/sti
COPY bin/ $STI_SCRIPTS_PATH
RUN chmod -R a+rx ${STI_SCRIPTS_PATH} && \
    chown -R ${USER_ID}:0 ${STI_SCRIPTS_PATH}

# In order to drop the root user, we have to make some directories world
# writeable as OpenShift default security model is to run the container
# under random UID.
RUN mkdir -p ${APP_ROOT} && \
    chmod -R u+rx ${APP_ROOT} && \
    chown -R ${USER_ID}:0 ${APP_ROOT}

# The default user in the image
USER ${USER_ID}

# Set the default port for applications built using this image
EXPOSE 8080

# Set the default CMD for the image
WORKDIR ${APP_ROOT}
CMD $STI_SCRIPTS_PATH/usage