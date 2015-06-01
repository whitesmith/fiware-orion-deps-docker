# whitesmith/fiware-orion-deps Dockerfile
This Dockerfile installs and builds the dependencies of [FIWARE][]'s
implementation of the [Publish/Subscribe Context Broker GE][] specification:
the [Orion Context Broker][].

It is based on the [CentOS Vagrant bootstrap script][], but attempts to keep its
size smaller:

* No test-related dependencies are installed.
* Every downloaded source is removed after installation (during the same
`RUN` command).
* **MongoDB server is not installed**. Unlike other FIWARE Orion Context Broker
Docker images, this image follows the [single-process per container][] practice
and favors [container linking][].

The resulting image is used by [whitesmith/fiware-orion-docker][] as a parent
image, to enable a faster re-build process in the case of updates (since the
dependencies are cached and not expected to be changed often).

**The [whitesmith/fiware-orion-docker][] repo also contains a basic
`docker-compose.yml` for setting up the necessary MongoDB database.**


## Usage
This image is not available at the [Docker Hub][] (**yet**); as such, it must be
built before being used by [whitesmith/fiware-orion-docker][] for now. Just run

```
  docker build -t whitesmith/fiware-orion-deps:latest .
```

After the building process finishes, it is ready to be used as parent image of
[whitesmith/fiware-orion-docker][].


[FIWARE]: http://www.fiware.org/
[Publish/Subscribe Context Broker GE]: https://forge.fiware.org/plugins/mediawiki/wiki/fiware/index.php/FIWARE.OpenSpecification.Data.ContextBroker
[Orion Context Broker]: http://catalogue.fi-ware.eu/enablers/publishsubscribe-context-broker-orion-context-broker
[CentOS Vagrant bootstrap script]: https://github.com/telefonicaid/fiware-orion/blob/e58f021f22224792780908e2eb43d21bf1e62e82/scripts/bootstrap/centos65.sh

[single-process per container]: https://docs.docker.com/articles/dockerfile_best-practices/#run-only-one-process-per-container
[container linking]: https://docs.docker.com/userguide/dockerlinks/

[whitesmith/fiware-orion-docker]: https://github.com/whitesmith/fiware-orion-docker

[Docker Hub]: https://registry.hub.docker.com/
