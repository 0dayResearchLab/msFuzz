# MS Fuzz : 
**MS Fuzzer** is coverage-guided Fuzzer that is targeting Windows Kernel Driver.

## Feature
- **MS Fuzzer** uses [_Intel PT_](https://www.intel.com/content/www/us/en/developer/videos/collecting-processor-trace-in-intel-system-debugger.html) to achieve code coverage. 
- The **MS Fuzzer** follows an AFL-like design and can detect semi-stateful bugs.
- **MS Fuzzer** is a well-designed fuzzer based on [_Nyx-Fuzzer_](https://nyx-fuzz.com) / [_kAFL_](https://github.com/IntelLabs/kAFL) and [_Redqueen_](https://github.com/RUB-SysSec/redqueen).
- Designed to find bugs for windows Driver that interact with user with **DeviceIoControl**.

## Requirements

- **Intel Skylake or later:** The setup requires a Gen-6 or newer Intel CPU (for
  Intel PT) and adequate system memory (~2GB RAM per CPU)

- **Patched Host Kernel:** A modified Linux host kernel will be installed as part
  of the setup. Running kAFL inside a VM may work starting IceLake or later CPU.

- **Ubuntu:** The installation and tutorials are
  tested for recent Ubuntu 20.04.6 LTS.

## How to use
```
aaa
aaaa
aaa
```
