################# BASE IMAGE ######################
FROM --platform=linux/amd64 continuumio/miniconda3:22.11.1
# Debian-based image with Miniconda3 and some utils

################## METADATA ######################
LABEL base_image="continuumio/miniconda3:22.11.1"
LABEL version="1.1.0"
LABEL software="HISAT2"
LABEL software.version="2.2.1"
LABEL about.summary="HISAT2 is a fast and sensitive alignment program for mapping next-generation sequencing reads (both DNA and RNA) to a population of human genomes as well as to a single reference genome."
LABEL about.home="https://daehwankimlab.github.io/hisat2/"
LABEL about.documentation="https://daehwankimlab.github.io/hisat2/manual/"
LABEL about.license_file="https://github.com/DaehwanKimLab/hisat2/blob/master/LICENSE"
LABEL about.license="GNU GPL3"

################## MAINTAINER ######################
MAINTAINER Matthew Galbraith <matthew.galbraith@cuanschutz.edu>


################## INSTALLATION ######################
ENV DEBIAN_FRONTEND noninteractive
ARG ENV_NAME="hisat2"

# Install mamba
RUN conda install -n base conda-forge::mamba
RUN mamba install -y hisat2=2.2.1 -c bioconda && conda clean -a

# Add conda installation dir to PATH (instead of doing 'conda activate')
ENV PATH /opt/conda/envs/bin:$PATH



