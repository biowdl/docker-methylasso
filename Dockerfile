FROM mambaorg/micromamba:2.3.0-debian11

WORKDIR /methylasso

USER root
RUN apt -y update && apt install -y git
RUN git clone -b v1.0.0 https://github.com/bardetlab/methylasso .

RUN micromamba install -y -n base -f conda_env.yml \
    && micromamba install -y -n base gcc gxx conda-forge::procps-ng \
    && micromamba env export --name base --explicit > environment.lock \
    && echo ">> CONDA_LOCK_START" \
    && cat environment.lock \
    && echo "<< CONDA_LOCK_END" \
    && micromamba clean -a -y
# USER root
ENV PATH="$MAMBA_ROOT_PREFIX/bin:$PATH"

RUN R CMD INSTALL --preclean .
