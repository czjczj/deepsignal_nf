#!/usr/bin/bash
  
# 1. install anaconda
if [ ! -d "${PWD}/miniconda" ]; then
    #wget "https://mirrors.tuna.tsinghua.edu.cn/anaconda/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O ./miniconda.sh
    #wget "https://repo.anaconda.com/miniconda/Miniconda3-latest-Linux-x86_64.sh" -O ./miniconda.sh
    #wget "https://mirrors.tuna.tsinghua.edu.cn/anaconda/archive/Anaconda3-5.3.1-Linux-x86_64.sh" -O ./miniconda.sh
    wget http://mirrors.ustc.edu.cn/anaconda/archive/Anaconda3-5.3.1-Linux-x86_64.sh -O ./miniconda.sh

    bash ./miniconda.sh -b -p $PWD/miniconda
    $PWD/miniconda/bin/conda init $(echo $SHELL | awk -F '/' '{print $NF}')
    echo 'Successfully installed miniconda'
    echo -n 'Conda version'
    $PWD/miniconda/bin/conda --version
    echo -e '\n'
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/conda-forge/
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/free/
    conda config --add channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/pkgs/main/
    conda config --append channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/fastai/
    conda config --append channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/pytorch/
    conda config --append channels https://mirrors.tuna.tsinghua.edu.cn/anaconda/cloud/bioconda/
    conda config --set show_channel_urls yes
fi


# 2. install conda environment according to 'environment.yaml' 
if [ ${conda env list | grep 'deepsignalenv' | wc -l} == 0 ]; then
    conda env create -f environment.yaml
    conda activate deepsignalenv 
fi

# 3. run main.nf for deepsingal
next run main.nf

