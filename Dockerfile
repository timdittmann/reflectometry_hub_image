#https://github.com/2i2c-org/coessing-image/blob/main/Dockerfile
FROM pangeo/pangeo-notebook:2023.07.05

USER root
ENV DEBIAN_FRONTEND=noninteractive
ENV PATH ${NB_PYTHON_PREFIX}/bin:$PATH

# Needed for apt-key to work
RUN apt-get update -qq --yes > /dev/null && \
    apt-get install --yes -qq gnupg2 > /dev/null

# GNSSREFL
# build requirements
RUN apt-get update && \
  apt-get install -y gfortran python3-pip unzip wget vim

WORKDIR /srv
RUN git clone https://github.com/s-watanabe-jhod/garpos.git

WORKDIR ${HOME}
USER ${NB_USER}

COPY environment.yml /tmp/

RUN mamba env update --name ${CONDA_ENV} -f /tmp/environment.yml

# Remove nb_conda_kernels from the env for now
RUN mamba remove -n ${CONDA_ENV} nb_conda_kernels

#COPY install-jupyter-extensions.bash /tmp/install-jupyter-extensions.bash
#RUN /tmp/install-jupyter-extensions.bash


# Set bash as shell in terminado.
# ADD jupyter_notebook_config.py  ${NB_PYTHON_PREFIX}/etc/jupyter/
# Disable history.
# ADD ipython_config.py ${NB_PYTHON_PREFIX}/etc/ipython/
