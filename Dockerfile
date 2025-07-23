FROM posit/r-base:4.3.3-noble

RUN apt update && apt install -y wget unzip
RUN wget https://github.com/bardetlab/methylasso/archive/refs/heads/main.zip && unzip main.zip && rm main.zip

WORKDIR methylasso-main

RUN Rscript -e 'options(repos = c(binary = "https://packagemanager.rstudio.com/all/__linux__/noble/latest",CRAN = "https://packagemanager.posit.co/cran/2024-12-12")); install.packages(c("Rcpp", "RcppEigen", "BH", "RcppGSL", "doParallel", "ggrepel", "data.table", "foreach", "ggplot2", "scales", "matrix", "matrixstats", "R.utils", "stringr"), binary=T)'

RUN Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/Matrix/Matrix_1.6-5.tar.gz', repos = NULL)"
RUN Rscript -e "install.packages('https://cran.r-project.org/src/contrib/Archive/matrixStats/matrixStats_1.3.0.tar.gz', repos = NULL)"

RUN apt install -y libgsl-dev libgsl27
RUN ln -s /usr/lib/x86_64-linux-gnu/libgsl.so.27.0.0 /usr/lib/x86_64-linux-gnu/libgsl.so.19

RUN R CMD INSTALL .

ENTRYPOINT ["Rscript", "/methylasso-main/MethyLasso.R"]
