# define parent
FROM centos:7

# define maintainer
MAINTAINER Andreas Guther andreas@guther.net

# labels
LABEL version="2.0" \
      version.application="2.0" \
      version.rti="5.2.5" \
      description="Docker image with RTI Perftest. RTI Perftest is a command-line application that measures the Latency and Throughput of very configurable scenarios that use RTI Connext DDS middleware to send messages."

# environment variables
ENV RTI_PERFTEST_ARCHIVE=/rti_perftest-2.0-rti_connext_dds-5.2.5-x64Linux.tar.gz \
    RTI_PERFTEST_EXTRACT_DIRECTORY=/perftest-2.0-RTI-Connext-DDS-5.2.5-x64Linux2.6gcc4.1.1 \
    RTI_PERFTEST_TARGET_DIRECTORY_PARENT=/opt/rti/connext-dds \
    RTI_PERFTEST_TARGET_DIRECTORY_NAME=perftest

# add RTI Perftest binary package
ADD https://github.com/rticommunity/rtiperftest/releases/download/v2.0/rti_perftest-2.0-rti_connext_dds-5.2.5-x64Linux.tar.gz ${RTI_PERFTEST_ARCHIVE}

# extract archive
RUN groupadd -r app \
 && useradd -r -g app app \
 && tar xzf $RTI_PERFTEST_ARCHIVE \
 && rm -f $RTI_PERFTEST_ARCHIVE \
 && mkdir -p $RTI_PERFTEST_TARGET_DIRECTORY_PARENT \
 && mv $RTI_PERFTEST_EXTRACT_DIRECTORY -t $RTI_PERFTEST_TARGET_DIRECTORY_PARENT \
 && mv $RTI_PERFTEST_TARGET_DIRECTORY_PARENT$RTI_PERFTEST_EXTRACT_DIRECTORY $RTI_PERFTEST_TARGET_DIRECTORY_PARENT/$RTI_PERFTEST_TARGET_DIRECTORY_NAME \
 && ln -s $RTI_PERFTEST_TARGET_DIRECTORY_PARENT/$RTI_PERFTEST_TARGET_DIRECTORY_NAME/bin/x64Linux2.6gcc4.1.1/release/perftest_cpp /usr/bin/perftest_cpp \
 && chown -R app:app $RTI_PERFTEST_TARGET_DIRECTORY_PARENT

# switch user to non-root
USER app

# set stop signal
STOPSIGNAL SIGKILL

# define work directory and entrypoint
WORKDIR "${RTI_PERFTEST_TARGET_DIRECTORY_PARENT}/${RTI_PERFTEST_TARGET_DIRECTORY_NAME}"
ENTRYPOINT ["/usr/bin/perftest_cpp"]
