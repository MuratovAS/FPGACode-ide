# FPGACode-ide

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

The first thing to do is create a directory for assembly
```bash 
mkdir -p build
```

It is also necessary to install `Toolchain`. Installation to the Directory `/opt/fpga`. The directory can be configured in `Makefile`.
The list of established components is configured in `./toolchain/Toolchain.txt`
```bash
make toolchain
```
Next, you can establish the necessary expansion, this will increase the convenience of development.

## Extensions for Code

Basic extensions:
|Name           |Developer   |Description           |URL |
|---------------|------------|----------------------|----|
|Verilog-HDL    |mshr-h      |Highlight and lint    |[✅](https://https://open-vsx.org/extension/mshr-h/veriloghdl)[🔽](https://github.com/MuratovAS/vscode-verilog-hdl-support)|
|Impulse        |toem-de     |VCD visualization     |[✅](https://open-vsx.org/extension/toem-de/impulse)|
|DigitalJS      |yuyichao    |Interactive simulator |[✅](https://open-vsx.org/extension/yuyichao/digitaljs)|

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
make flash       #Flash ROM
make prog       #Flash SRAM
make clean      #Cleaning the assembly of the project
make formatter  #Perform code formatting
make toolchain  #Install assembly tools
```

## The project structure

...