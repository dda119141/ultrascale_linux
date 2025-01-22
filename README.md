# Motivation

This repository offers a comprehensive build system utilizing YAML-based task files for Linux development on AMD's Xilinx Zynq Ultrascale+ SOC. Adhering to the YAGNI (You Aren't Gonna Need It) principle, the project focuses on efficiently retrieving essential host and target dependencies required for embedded Linux build and deployment on Zynq Ultrascale.

Leveraging Taskfile, a Go-language task management tool, the system provides transparent and streamlined component build procedures through YAML schema files. By simplifying the build process, this approach enhances clarity and reduces complexity in managing Linux build configurations for Armv8a architecture.

The primary objective is to create a robust, minimalist build framework for Xilinx Ultrascale+ embedded systems. Moreover, it enables the user to develop or adapt hardware related OS components using qemu in a simple way.

For more informations on task files visit:

https://taskfile.dev/

---

# Prerequisites

Currently, only Ubuntu host operating systems from version 20.04 and later are supported. 

---

# Installation

Installation of the task utility can be accomplished by following the steps outlined in this link.

https://taskfile.dev/installation/#install-script

---

# Use Cases

The following workflow describes the main components built within this solution.

![Main use cases](files/build_qemu_os.drawio.svg)

---

# Usage

Instructions to list all commands accessible at the topmost level of the directory tree.

```bash

task -l

```



