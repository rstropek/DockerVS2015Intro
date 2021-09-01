# Docker and .NET - Tips and Tricks

## Official Images

* [.NET official images on Docker Hub](https://hub.docker.com/_/microsoft-dotnet)
* [Sources on GitHub](https://github.com/dotnet/dotnet-docker/)
* Variants
  * [SDK](https://hub.docker.com/_/microsoft-dotnet-sdk/)
    * For coding and building
  * [ASP.NET Core Runtime](https://hub.docker.com/_/microsoft-dotnet-aspnet/)
    * For running ASP.NET Core apps ([framework-dependent deployment](https://docs.microsoft.com/en-us/dotnet/core/deploying/)) in production
  * [Runtime](https://hub.docker.com/_/microsoft-dotnet-runtime/)
    * For running .NET apps ([framework-dependent deployment](https://docs.microsoft.com/en-us/dotnet/core/deploying/)) in production
  * [Runtime dependencies](https://hub.docker.com/_/microsoft-dotnet-runtime-deps/)
    * For running .NET apps ([self-contained deployment](https://docs.microsoft.com/en-us/dotnet/core/deploying/)) in production
  * [Monitor](https://hub.docker.com/_/microsoft-dotnet-monitor/)
    * Sidecar container for collecting diagnostic information
  * [Samples](https://hub.docker.com/_/microsoft-dotnet-samples/)
  * What if none of the existing images fit your needs and you need to install .NET in your own Dockerfile?
    * See [code snippets for .NET install in Dockerfile](https://github.com/dotnet/dotnet-docker/blob/main/documentation/scenarios/installing-dotnet.md)
* Hierarchy of standard images
  * *SDK* [is based on](https://github.com/dotnet/dotnet-docker/blob/3b02c5dcd3780ec66ee6b178d0f2d15f994841b8/src/sdk/6.0/bullseye-slim/amd64/Dockerfile#L1)...
  * *aspnet*, [which is based on](https://github.com/dotnet/dotnet-docker/blob/3b02c5dcd3780ec66ee6b178d0f2d15f994841b8/src/aspnet/6.0/bullseye-slim/amd64/Dockerfile#L1)...
  * *runtime*, [which is based on](https://github.com/dotnet/dotnet-docker/blob/3b02c5dcd3780ec66ee6b178d0f2d15f994841b8/src/runtime/6.0/bullseye-slim/amd64/Dockerfile#L1)...
  * *runtime-deps*, [which is based on](https://github.com/dotnet/dotnet-docker/blob/3b02c5dcd3780ec66ee6b178d0f2d15f994841b8/src/runtime-deps/6.0/bullseye-slim/amd64/Dockerfile#L1)...
  * the underlying Linux distro
* [Image Update Policy](https://github.com/dotnet/dotnet-docker#image-update-policy)
  * Updated within 12 hours after update of base image (e.g. Linux distro)
  * New images appear shortly after or in parallel with release of .NET versions (including previews)
* [Platforms](https://github.com/dotnet/dotnet-docker/blob/main/documentation/supported-platforms.md)
  * Linux: Alpine, Debian, Ubuntu
  * Windows: Server Core, Nano Server
  * Check lifetime policies!
  * Linux/Windows x86-64 (*amd64*)
  * Linux ARMv7 32-bit (*arm32v7*)
  * Linux ARMv8 64-bit (*arm64v8*)
* [Tagging](https://github.com/dotnet/dotnet-docker/blob/main/documentation/supported-tags.md)
  * Simple tags (e.g. *6.0.100-preview.7-bullseye-slim-amd64*) according to schema `<Major.Minor .NET Version>-<OS>-<Architecture>`
  * Shared tags (e.g. *6.0.100-preview.7*) reference images for multiple platforms
    * Docker will pick proper platform
    * If no OS is specified...
      * ...Debian is used when on Linux
      * ...Nano Server is used when on Windows

## Writing Dockerfiles For .NET Apps

* In general: Follow [samples provided by Microsoft](https://github.com/dotnet/dotnet-docker/tree/main/samples)
* [Multi-stage build](https://docs.microsoft.com/en-us/visualstudio/containers/container-build#multistage-build)
  * [Restore, build, and generate resulting image in multiple stages](https://github.com/dotnet/dotnet-docker/blob/main/samples/dotnetapp/Dockerfile)
  * [Run tests during image build](https://github.com/dotnet/dotnet-docker/blob/main/samples/complexapp/Dockerfile)
  * Discuss: When to build in Dockerfile, when to build in e.g. GitHub Actions?
* [Generate Dockerfile with Visual Studio](https://docs.microsoft.com/en-us/visualstudio/containers/container-tools)


