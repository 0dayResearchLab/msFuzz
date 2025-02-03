# MS Fuzz
**MS Fuzzer** is coverage-guided Fuzzer that is targeting Windows Kernel Driver.



<p align="center">
  <a href="https://github.com/0dayResearchLab/kAFL/actions/workflows/CI.yml">
    <img src="https://github.com/0dayResearchLab/kAFL/actions/workflows/CI.yml/badge.svg" alt="CI">
  </a>
</p>

## Feature
- **MS Fuzzer** uses [_Intel PT_](https://www.intel.com/content/www/us/en/developer/videos/collecting-processor-trace-in-intel-system-debugger.html) to achieve code coverage. 
- The **MS Fuzzer** follows an AFL-like design and can detect semi-stateful bugs.
- **MS Fuzzer** is a well-designed fuzzer based on [_Nyx-Fuzzer_](https://nyx-fuzz.com)/[_kAFL_](https://github.com/IntelLabs/kAFL) and [_Redqueen_](https://github.com/RUB-SysSec/redqueen).
- Designed to find bugs for windows Driver that interact with user using **DeviceIoControl**.
![Fuzz Success](docs/installation/fuzz_overall.png?raw=true)
## Requirements

- **Intel Skylake or later:** The setup requires a Gen-6 or newer Intel CPU (for
  Intel PT) and adequate system memory (~2GB RAM per CPU)

- **Patched Host Kernel:** A modified Linux host kernel will be installed as part
  of the setup. Running kAFL inside a VM may work starting IceLake or later CPU.

- **Ubuntu:** The installation and tutorials are
  tested for recent Ubuntu 20.04.6 LTS.
## Our Achievements
- 100+ Security Bugs in 100 days
- 20+ EoP (Elevation of Privilege)

## Talks & More Details
- [_CodeBlue2024_](https://codeblue.jp/en/program/time-table/day2-010/) ([_Slides_](CODEBLUE2024.pdf)) 

## How to use
- [_How to use_](docs/installation/README.md)
