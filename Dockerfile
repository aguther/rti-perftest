# define parent
FROM centos:7

# define maintainer
MAINTAINER Andreas Guther andreas@guther.net

# arguments
ARG version=2.0
ARG version_rti=5.2.5
ARG target_platform=x64Linux
ARG target_compiler=2.6gcc4.1.1

# labels
LABEL version="$version" \
      version.application="$version" \
      version.rti="$version_rti" \
      target="$target_platform$target_compiler" \
      description="Docker image with RTI Perftest. RTI Perftest is a command-line application that measures the Latency and Throughput of very configurable scenarios that use RTI Connext DDS middleware to send messages."

# environment variables
ENV RTI_PERFTEST_ARCHIVE=/rti_perftest-${version}-rti_connext_dds-${version_rti}-${target_platform}.tar.gz \
    RTI_PERFTEST_EXTRACT_DIRECTORY=/perftest-${version}-RTI-Connext-DDS-${version_rti}-${target_platform}${target_compiler} \
    RTI_PERFTEST_TARGET_DIRECTORY_PARENT=/opt/rti/connext-dds \
    RTI_PERFTEST_TARGET_DIRECTORY_NAME=perftest

# add RTI Perftest binary package
ADD https://github.com/rticommunity/rtiperftest/releases/download/v${version}/rti_perftest-${version}-rti_connext_dds-${version_rti}-${target_platform}.tar.gz ${RTI_PERFTEST_ARCHIVE}

# extract archive
RUN groupadd -r app \
 && useradd -r -g app app \
 && tar xzf $RTI_PERFTEST_ARCHIVE \
 && rm -f $RTI_PERFTEST_ARCHIVE \
 && mkdir -p $RTI_PERFTEST_TARGET_DIRECTORY_PARENT \
 && mv $RTI_PERFTEST_EXTRACT_DIRECTORY -t $RTI_PERFTEST_TARGET_DIRECTORY_PARENT \
 && mv $RTI_PERFTEST_TARGET_DIRECTORY_PARENT$RTI_PERFTEST_EXTRACT_DIRECTORY $RTI_PERFTEST_TARGET_DIRECTORY_PARENT/$RTI_PERFTEST_TARGET_DIRECTORY_NAME \
 && ln -s $RTI_PERFTEST_TARGET_DIRECTORY_PARENT/$RTI_PERFTEST_TARGET_DIRECTORY_NAME/bin/${target_platform}${target_compiler}/release/perftest_cpp /usr/bin/perftest_cpp \
 && chown -R app:app $RTI_PERFTEST_TARGET_DIRECTORY_PARENT

# switch user to non-root
USER app

# set stop signal
STOPSIGNAL SIGKILL

# define work directory and entrypoint
WORKDIR "${RTI_PERFTEST_TARGET_DIRECTORY_PARENT}/${RTI_PERFTEST_TARGET_DIRECTORY_NAME}"
ENTRYPOINT ["/usr/bin/perftest_cpp"]
