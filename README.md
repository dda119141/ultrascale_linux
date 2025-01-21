# Motivation

This repository offers a comprehensive build system utilizing YAML-based task files for Linux development on AMD's Xilinx Zynq Ultrascale+ SOC. Adhering to the YAGNI (You Aren't Gonna Need It) principle, the project focuses on efficiently retrieving essential host and target dependencies required for embedded Linux deployment.

Leveraging Taskfile, a Go-language task management tool, the system provides transparent and streamlined component build procedures through YAML schema files. By simplifying the build process, this approach enhances clarity and reduces complexity in managing Linux build configurations for Armv8a architecture.

The primary objective is to create a robust, minimalist build framework for Xilinx Ultrascale+ embedded systems.

For more informations on task files visit:

https://taskfile.dev/


---

## Use Cases

The following workflow describes the main components built within this solution.

![Main use cases](files/build_qemu_os.drawio.svg)






