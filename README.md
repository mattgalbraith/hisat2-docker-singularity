[![Docker Image CI](https://github.com/mattgalbraith/hisat2-docker-singularity/actions/workflows/docker-image.yml/badge.svg)](https://github.com/mattgalbraith/hisat2-docker-singularity/actions/workflows/docker-image.yml)

# hisat2-docker-singularity

## Build Docker container for HISAT2 and (optionally) convert to Apptainer/Singularity.  

HISAT2 is a fast and sensitive alignment program for mapping next-generation sequencing reads (both DNA and RNA) to a population of human genomes as well as to a single reference genome.  
  
#### Requirements:
Python (at least for hisat2-build)
Perl
  
## Build docker container:  

### 1. For TOOL installation instructions:  
https://daehwankimlab.github.io/hisat2/download/  
https://daehwankimlab.github.io/hisat2/manual/  


### 2. Build the Docker Image

#### To build image from the command line:  
``` bash
# Assumes current working directory is the top-level <tool>-docker-singularity directory
docker build -t hisat2:2.2.1 . # tag should match software version
```
* Can do this on [Google shell](https://shell.cloud.google.com)

#### To test this tool from the command line:
``` bash
docker run --rm -it hisat2:2.2.1 hisat2 --help

# binary download includes example index and reads for testing:
docker run -ti --rm -v `pwd`:/data -w /data hisat2:2.2.1 \
	bash -c "hisat2 -x /data/example_data/index/22_20-21M_snp -1 /data/example_data/reads/reads_1.fa -2 /data/example_data/reads/reads_2.fa -f > /dev/null"
	# -x denotes basename of index files; -1/-2 paired read files; -f input fasta format; > /dev/null sends sam out put to void so we just see standard out message; all wrapped in bash -c or everything goes to /dev/null
# SUCCESSFUL TEST RESULT: Alignment summary with 100% overall alignment rate

docker run -ti --rm -v `pwd`:/data -w /data hisat2:2.2.1 \
	hisat2-build /data/example_data/reference/22_20-21M.fa /dev/null
	# resulting index just sent to /dev/null
# SUCCESSFUL TEST RESULT: index build messages
```

## Optional: Conversion of Docker image to Singularity  

### 3. Build a Docker image to run Singularity  
(skip if this image is already on your system)  
https://github.com/mattgalbraith/singularity-docker

### 4. Save Docker image as tar and convert to sif (using singularity run from Docker container)  
``` bash
docker images
docker save <Image_ID> -o hisat2_2.2.1-docker.tar && gzip hisat2_2.2.1-docker.tar # = IMAGE_ID of <tool> image
docker run -v "$PWD":/data --rm -it singularity:1.1.5 bash -c "singularity build /data/hisat2_2.2.1.sif docker-archive:///data/hisat2_2.2.1-docker.tar.gz"
```
NB: On Apple M1/M2 machines ensure Singularity image is built with x86_64 architecture or sif may get built with arm64  

Next, transfer the hisat2_2.2.1.sif file to the system on which you want to run HISAT2 from the Singularity container  

### 5. Test singularity container on (HPC) system with Singularity/Apptainer available  
``` bash
# set up path to the Singularity container
HISAT2_SIF=path/to/hisat2_2.2.1.sif

# Test that <tool> can run from Singularity container
singularity run $HISAT2_SIF hisat2 --help # depending on system/version, singularity may be called apptainer
```