# FPGACode-ide

![](assets/2022-05-27-01-22-30.png)

This repository contains a simple project for `Icebreaker fpga` built on `Makefile` and open `Toolchain`, which allows us to use `code` as a full -fledged development environment.

As an editor of the code can be absolutely anything from `vim` to `vscode`, there is no binding to the editor. I am using `uncoded`. It is `*code*` that editor makes it possible to conveniently visualize the development process, due to extensions.

## Installation of dependencies

For example, consider installation on Ubuntu

```bash
sudo apt install openjdk-8-jdk openjdk-8-jre #It is necessary for impulse and verilog-format
sudo apt install curl unzip #It is necessary for installation toolchain
sudo apt install code #Any variety of VSCODE
```

## First start

The first thing to do is to install `Toolchain`. Installation to the Directory `/opt/fpga`. The directory can be configured in `Makefile`.
The list of established components is configured in `./toolchain/Toolchain.txt`
```bash
make toolchain
```
Next, you can establish the necessary expansion.

## Extensions for Code

Basic extensions:
|Name               |Developer   |Description           |URL |
|-------------------|------------|----------------------|----|
|Verilog-HDL >=1.5.4|mshr-h      |Highlight and lint    |[🔽](https://github.com/MuratovAS/vscode-verilog-hdl-support)|
|Impulse            |toem-de     |VCD visualization     |[✅](https://open-vsx.org/extension/toem-de/impulse)|
|DigitalJS          |yuyichao    |Interactive simulator |[✅](https://open-vsx.org/extension/yuyichao/digitaljs)|

Additional extensions:
|Name             |Developer   |Description       |Notes                 |URL |
|-----------------|------------|------------------|----------------------|----|
|TODO Highlight   |wayou       |Highlight notes   |Just a useful thing   |[✅](https://open-vsx.org/extension/wayou/vscode-todo-highlight)|
|WaveTrace        |wavetrace   |VCD visualization |Analogue `Impulse`    |[⬇️](https://marketplace.visualstudio.com/items?itemName=wavetrace.wavetrace)|
|Verilog Highlight|tzylee      |Highlight syntax  |Analogue `Verilog-HDL`|[⬇️](https://marketplace.visualstudio.com/items?itemName=tzylee.verilog-highlight)|

## Usage

The commands can be executed manually in the terminal as well as through the `Task menu` in `Code`

```bash
make all        #Project assembly
make sim        #Perform Testbench
make flash      #Flash ROM
make prog       #Flash SRAM
make clean      #Cleaning the assembly of the project
make formatter  #Perform code formatting
make toolchain  #Install assembly tools
```

## Project structure

- .vscode - Directory сonfiguration for vscode
    - settings.json - Contains Linter settings
    - tasks.json - Contains instructions for launching Makefile
- build - Directory of assembly artifacts
    - *.vcd - The file contains temporary diagrams (result of modeling)
    - *.bin - The final firmware file
- src - Directory of source files
    - *.v - Source code
    - *_tb.v - Test Bench
    - top.v - Initial file
- toolchain - Directory of scripts for the assembly of Toolchain
- .verilog-format - Code style configuration file
- *.pcf - Pin planner
- Makefile - Assembly system
- toolchain.txt - List of tools used

## Turn on hot keys

There was no simple way to reassign the keys for the working area. For this reason, a change in the global configuration will be required. This can be done by adding to the file `keybindings.json`

```json
{
    "key": "alt+shift+a",
    "command": "workbench.action.tasks.runTask",
    "args": "PRJ: make all"
},
{
    "key": "alt+shift+s",
    "command": "workbench.action.tasks.runTask",
    "args": "PRJ: make sim"
},
{
    "key": "alt+shift+c",
    "command": "workbench.action.tasks.runTask",
    "args": "PRJ: make clean"
},
{
    "key": "alt+shift+e",
    "command": "workbench.action.tasks.runTask",
    "args": "PRJ: make flash"
},
{
    "key": "alt+shift+r",
    "command": "workbench.action.tasks.runTask",
    "args": "PRJ: make prog"
},
{
    "key": "alt+shift+x",
    "command": "workbench.action.tasks.runTask",
    "args": "PRJ: make formatter"
},
```
