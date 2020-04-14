<!-- PROJECT SHIELDS -->
<!--
*** See the bottom of this document for the declaration of the reference variables
*** for contributors-url, forks-url, etc. This is an optional, concise syntax you may use.
*** https://www.markdownguide.org/basic-syntax/#reference-style-links
-->

[![Contributors][contributors-shield]][contributors-url]
[![Forks][forks-shield]][forks-url]
[![Stargazers][stars-shield]][stars-url]
[![Issues][issues-shield]][issues-url]
[![MIT License][license-shield]][license-url]
![Build][build-shield]

<!-- PROJECT LOGO -->
<br />
<p align="center">
  <a href="https://github.com/EOEPCA/um-login-service">
    <img src="images/logo.png" alt="Logo" width="80" height="80">
  </a>

  <h3 align="center">um-login-service</h3>

  <p align="center">
    <br />
    <a href="https://github.com/EOEPCA/um-login-service"><strong>Explore the docs »</strong></a>
    <br />
    <a href="https://github.com/EOEPCA/um-login-service">View Demo</a>
    ·
    <a href="https://github.com/EOEPCA/um-login-service/issues">Report Bug</a>
    ·
    <a href="https://github.com/EOEPCA/um-login-service/issues">Request Feature</a>
  </p>
</p>

<!-- TABLE OF CONTENTS -->

## Table of Contents

- [About the Project](#about-the-project)
  - [Built With](#built-with)
- [Getting Started](#getting-started)
  - [Prerequisites](#prerequisites)
  - [Installation](#installation)
  - [Testing](#testing)
- [Documentation](#documentation)
- [Usage](#usage)
- [Roadmap](#roadmap)
- [Contributing](#contributing)
- [License](#license)
- [Contact](#contact)
- [Acknowledgements](#acknowledgements)

<!-- ABOUT THE PROJECT -->

## About The Project

[![Product Name Screen Shot][product-screenshot]](https://example.com)

This building block aims at deploying a Gluu 3.1.6 instance.

### Built With

- [Javalin framework](https://javalin.io/)
- [Log4j2](https://logging.apache.org/log4j/2.x/) + [YAML](https://yaml.org/)
- [Junit 5](https://junit.org/junit5/)

<!-- GETTING STARTED -->

## Getting Started

To get a local copy up and running follow these simple steps.

### Prerequisites

This is an example of how to list things you need to use the software and how to install them.

- [Vagrant](https://www.vagrantup.com/docs/installation/)
- [EOEPCA Development Environment](https://github.com/EOEPCA/dev-env)

### Installation

1. Get into EOEPCA's development environment

```sh
vagrant ssh
```

3. Clone the repo

```sh
git clone https://github.com/EOEPCA/um-login-service.git
```

4. Change local directory

```sh
cd um-login-service\src
```

5. Run the script

```sh
sh ./setupCluster.sh
```

### Testing

Access the following endpoints to check functionality:
```sh
curl -XGET https://eoepca-dev.gluu.org/.well-known/openid-configuration -k
```
```sh
curl -XGET https://eoepca-dev.gluu.org/.well-known/scim-configuration -k
```

If you wish to access the UI via browser, run the following command from inside the VM:
```sh
sudo apt install firefox xorg
```

Then, using MobaXterm on the host machine and connecting to the VM, open firefox and access the following links:
https://eoepca-dev.gluu.org/.well-known/openid-configuration
https://eoepca-dev.gluu.org/.well-known/scim-configuration

## Documentation

The component documentation can be found at https://eoepca.github.io/um-login-service/.

<!-- ROADMAP -->

## Roadmap

See the [open issues](https://github.com/EOEPCA/um-login-service/issues) for a list of proposed features (and known issues).

<!-- CONTRIBUTING -->

## Contributing

Contributions are what make the open source community such an amazing place to be learn, inspire, and create. Any contributions you make are **greatly appreciated**.

1. Fork the Project
2. Create your Feature Branch (`git checkout -b feature/AmazingFeature`)
3. Commit your Changes (`git commit -m 'Add some AmazingFeature'`)
4. Push to the Branch (`git push origin feature/AmazingFeature`)
5. Open a Pull Request

<!-- LICENSE -->

## License

Distributed under the Apache-2.0 License. See `LICENSE` for more information.

<!-- CONTACT -->

## Contact

Tiago Mendonça Fernandes - tiago.fernandes@elecnor.es

Project Link: [https://github.com/EOEPCA/um-login-service](https://github.com/EOEPCA/um-login-service)

<!-- ACKNOWLEDGEMENTS -->

## Acknowledgements

- []()
- []()
- README.md is based on [this template](https://github.com/othneildrew/Best-README-Template) by [Othneil Drew](https://github.com/othneildrew).

<!-- MARKDOWN LINKS & IMAGES -->
<!-- https://www.markdownguide.org/basic-syntax/#reference-style-links -->

[contributors-shield]: https://img.shields.io/github/contributors/EOEPCA/um-login-service.svg?style=flat-square
[contributors-url]: https://github.com/EOEPCA/um-login-service/graphs/contributors
[forks-shield]: https://img.shields.io/github/forks/EOEPCA/um-login-service.svg?style=flat-square
[forks-url]: https://github.com/EOEPCA/um-login-service/network/members
[stars-shield]: https://img.shields.io/github/stars/EOEPCA/um-login-service.svg?style=flat-square
[stars-url]: https://github.com/EOEPCA/um-login-service/stargazers
[issues-shield]: https://img.shields.io/github/issues/EOEPCA/um-login-service.svg?style=flat-square
[issues-url]: https://github.com/EOEPCA/um-login-service/issues
[license-shield]: https://img.shields.io/github/license/EOEPCA/um-login-service.svg?style=flat-square
[license-url]: https://github.com/EOEPCA/um-login-service/blob/master/LICENSE
[build-shield]: https://www.travis-ci.com/EOEPCA/um-login-service.svg?branch=master
[product-screenshot]: images/screenshot.png
