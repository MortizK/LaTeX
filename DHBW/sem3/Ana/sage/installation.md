# Install Sage on Windows

First you need Windows Subsystem for Linux. There you can install Ubuntu, which can be launched with the search function of Windows.

## Installation

To install Sage you need to run the following commands in the Ubuntu shell

```sh
curl -L -O "https://github.com/conda-forge/miniforge/releases/latest/download/Miniforge3-$(uname)-$(uname -m).sh"
bash Miniforge3-$(uname)-$(uname -m).sh
eval "$(/home/USERNAME/miniforge3/bin/conda shell.bash hook)"
conda create -n sage sage python=3.11
```

Note: The `eval` is used to switch to a conda environment. If your consol ist not the `bash`-console. You can find out your console by:

```sh
echo $0
```

## Switch to sage-environment

To use any sage function you will need to get into the sage environment.

```sh
eval "$(/home/USERNAME/miniforge3/bin/conda shell.bash hook)"
conda activate sage
```

## Starting sage-console

You need to be in the sage-environment for this step!

The following will start the sage-console

```sh
sage
```

to quit the sage-console, type "quit" and press ENTER.

## Starting the notebook

You need to be in the sage-environment for this step!

To see a notebook can run with or without the `--port` flag.

```sh
sage -n jupyter
sage -n jupyter --port 8899
```

# Sources

* [willhoffer.com](https://willhoffer.com/2023-06-10/how-to-install-sage-on-windows/)
* [doc.sagemath.org](https://doc.sagemath.org/html/en/installation/)
* [doc.sagemath.org launching](https://doc.sagemath.org/html/en/installation/launching.html#sec-launching)