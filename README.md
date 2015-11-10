# Topbeat Docker Container

# Build

Download the official image from Docker Hub:

```
# docker pull proteansec/topbeat
```

# Run

Run the image by giving it access to the host in order to be able to access system load, disk usage, memory usage, status of processes as well as CPU Usage.

```
docker run --privileged -d proteansec/topbeat app:start
```
