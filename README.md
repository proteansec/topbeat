# proteansec/topbeat

- [Introduction](#introduction)
- [Contributing](#contributing)
- [Prerequisites](#prerequisites)
- [Installation](#installation)
- [Quick Start](#quick-start)
- [Limitations](#limitations)
- [Configuration Parameters](#configuration-parameters)

# Introduction

Dockerfile to build a [Topbeat](https://www.elastic.co/downloads/beats/topbeat) container image.

# Contributing

If you find this image useful you can help by doing one of the following:

- *Send a Pull Request*: you can add new features to the docker image, which will be integrated into the official image.
- *Report a Bug*: if you notice a bug, please issue a bug report at [Issues](https://github.com/proteansec/topbeat/issues), so we can fix it as soon as possible.

# Prerequisites

**Host Access**

You need to give your image access to the host by running the container in privileged mode, so it will have access to the system information.

**Elasticsearch**

Prior to using this image, you should already have an instance of Elasticsearch running, which is accessible by Docker from where you intend to run this image.

# Installation

Automated builds of the image are available on [Dockerhub](https://hub.docker.com/r/proteansec/topbeat) and is the recommended method of installation.

```bash
docker pull proteansec/topbeat:latest
```

Alternatively you can build the image locally.

```bash
git clone https://github.com/proteansec/topbeat.git
cd topbeat
docker build -t proteansec/topbeat .
```

# Quick Start

We have to give topbeat container access to the host by specifying the **--privileged** parameter to be able to access the system information.

When running topbeat container on the same host as elasticsearch, we can run it with the following command, since the container connects to Elasticsearch on **localhost:9200** by default.

```bash
docker run --name topbeat -d --privileged -d proteansec/topbeat app:start
```

When running topbeat container on a different host as elasticsearch, we have to run it with appropriate environment variables:

```bash
docker run --name topbeat -d --privileged --env 'ELASTICHOSTS="\"host:920\""' -d proteansec/topbeat app:start
```

Now you should have the Topbeat running, which will be able to gather information from the system such as system load, disk usage, memory usage, status of processes as well as CPU usage and send it to Elasticsearch.

# Limitations

Running Topbeat in container is limiting due to the fact that you won't be able to monitor per-process statistics, since you'll only be able to see the processes in the current container. Nevertheless, you can monitor other system information if run in privileged mode.

The following is the output of `fdisk -l` command from Topbeat container when run in **non-privileged** mode, where none of the system partitions are visible.

```
root@49ed624f362b:/# fdisk -l
root@49ed624f362b:/#
```


The following is the output of `fdisk -l` command from Topbeat container when run in **privileged** mode, where system partitions are visible without any problems, the same as in docker host.

```
root@d7409f3a954a:/# fdisk -l

Disk /dev/sda: 214.7 GB, 214748364800 bytes
255 heads, 63 sectors/track, 26108 cylinders, total 419430400 sectors
Units = sectors of 1 * 512 = 512 bytes
Sector size (logical/physical): 512 bytes / 512 bytes
I/O size (minimum/optimal): 512 bytes / 512 bytes
Disk identifier: 0x00000000

   Device Boot      Start         End      Blocks   Id  System
/dev/sda1   *        4096      266239      131072    c  W95 FAT32 (LBA)
/dev/sda2               1        4095        2047+  ee  GPT

Partition table entries are not in disk order
```


# Configuration Parameters

*Refer to the documentation for the --env-file flag, which allows you to specify all environmental variables in a single file, which saves you from using overly complicated docker run commands.*

Below is the complete list of available options that can be used to customize your topbeat container instance.

- **ELASTICENABLED**: Set this to `true` to enable saving the traffic information to elasticsearch (default: true).
- **ELASTICHOSTS**: Elasticsearch hosts where the data will be saved.
- **LOGSTASHENABLED**: Set this to `true` to enable saving the traffic information to logstash (default: false).
- **LOGSTASHHOSTS**: Logstash hosts where the data will be saved.
- **FILEENABLED**: Set this to `true` to enable saving the traffic information to a file (default: false).
- **FILEPATH**: The file where the traffic will be saved.

