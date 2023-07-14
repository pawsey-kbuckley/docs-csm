# Cray System Management Documentation

This file is on a branch that allows for rendering of the content
with the Jekyll rendering tools.

There's no "fancy" style being applied at present but it does act
as a useful check to make sure that the way the Markdown is being
written doesn't preculde rendering with Jekyll.

Along with

* Adding some tooling files and scripts
* Adding some headers to all of the Markdown files
* Rewriting links so that they refer to the rendered dot-html
  files and not the dot-md source files

the main issue so far has been seen to be the way that some date
command format strings, which use curly brace plus percent as a
delimiter, within code blocks, require, for rendering with Jekyll,
the code block to be qualified with a raw/endraw pair.

Typically, one would do

* `make  jekyll-add-def-header`
* `make  jekyll-replace-md-links`
* `make  jekyll-show-brace_percent_str`

At this point, one can either protect the identified code blocks
by hand, or simply protect everyone, with a 

* `make jekyll-protect-code-blocks`

after which running a `jekyll build` or `jekyll serve` should
complete.

The branch can be returned to a clean state, after any Jekyll
work, by running

* `make jekyll-clean`

## The original content of the "main" branch README follows:

It follows this text.

* [Scope and audience](#scope-and-audience)
* [Table of contents](#table-of-contents)
* [Copyright and license](#copyright-and-license)

## Scope and audience

The documentation included here describes the Cray System Management (CSM) software, how to install
or upgrade CSM software, and related supporting operational procedures to manage an HPE Cray EX system.
CSM software is the foundation upon which other software product streams for the HPE Cray EX system depend.

The CSM installation prepares and deploys a distributed system across a group of management
nodes organized into a Kubernetes cluster which uses Ceph for utility storage. These nodes
perform their function as Kubernetes master nodes, Kubernetes worker nodes, or utility storage
nodes with the Ceph storage.

System services on these nodes are provided as containerized micro-services packaged for deployment
via Helm charts. Kubernetes orchestrates these services and schedules them on Kubernetes worker
nodes with horizontal scaling. Horizontal scales increases or decreases the number of service instances as
demand for them varies, such as when booting many compute nodes or application nodes.

This information is intended for system installers, system administrators, and network administrators
of the system. It assumes some familiarity with standard Linux and open source tools, such as shell
scripts, revision control with git, configuration management with Ansible, YAML, JSON, and TOML file formats, etc.

## Table of contents

1. [Introduction to CSM Installation](introduction/README.md)

   This chapter provides an introduction to using the CSM software to manage the HPE Cray EX system which
   also describes the scenarios for installation and upgrade of CSM software, how product stream updates
   for CSM are delivered, the operational activities done after installation for on-going management
   of the HPE Cray EX system, differences between previous release and this release, and conventions
   used in this documentation.

1. [Bare-Metal Steps](operations/bare_metal/Bare-Metal.md)

   This chapter outlines how to set up default credentials for River BMCs and
   ServerTech PDUs, which must be done before the initial installation of
   CSM, in order to enable HSM software to interact with River Redfish BMCs
   and PDUs.

1. [Update CSM Product Stream](update_product_stream/README.md)

   This chapter explains how to get the CSM product release, get any patches, update to the latest
   documentation, and check for any Field Notices or Hotfixes.

1. [Install CSM](install/README.md)

   This chapter provides an ordered list of procedures to follow when performing an initial install
   or a reinstall of CSM software. See the separate "Upgrade CSM" chapter for upgrade procedures.

1. [Upgrade CSM](upgrade/README.md)

   This chapter provides an ordered list of procedures which can be used to update CSM software that
   indicate when to do operational tasks as part of the software upgrade workflow. See the separate
   "Install CSM" chapter for initial install and reinstall procedures.

1. [CSM Operational Activities](operations/README.md)

   This chapter provides an unordered set of administrative procedures required to operate an HPE Cray EX system with CSM software and grouped into several major areas:
   * CSM Product Management
   * Artifact Management
   * Boot Orchestration
   * Compute Rolling Upgrade
   * Configuration Management
   * Console Management
   * Firmware Management
   * Hardware State Manager
   * Image Management
   * Kubernetes
   * Network Management
   * Node Management
   * Package Repository Management
   * Power Management
   * Resiliency
   * River Endpoint Discovery Service
   * Security And Authentication
   * System Configuration Service
   * System Layout Service
   * System Management Health
   * UAS User And Admin Topics
   * Utility Storage
   * Validate CSM Health

1. [CSM Troubleshooting Information](troubleshooting/README.md)

   This chapter provides information about some known issues in the system and tips for troubleshooting Kubernetes.

1. [CSM Background Information](background/README.md)

   This chapter provides background information about the NCNs (non-compute nodes) which function as
   management nodes for the HPE Cray EX system. This information is not normally needed to install
   or upgrade software, but provides background which might be helpful for troubleshooting an installation.

1. [CSM REST API Documentation](api/README.md)

    This chapter provides documentation on the REST APIs of the services in CSM.

1. [Glossary](glossary.md)

   This chapter provides explanations of terms and acronyms used throughout the rest of this documentation.

## Copyright and license

See [LICENSE](LICENSE).
