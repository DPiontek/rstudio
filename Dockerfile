# Base image
FROM rocker/rstudio:3.5.1

ENV DEBIAN_FRONTEND=noninteractive

# add RMakeflags
RUN mkdir -p ~/.R; echo 'MAKEFLAGS = -j4' >~/.R/Makevars

# Install dependencies -----------------------------------------------
RUN apt-get update && \
apt-get install -y ed \
libcairo2-dev \
libprotobuf-dev \
libjq-dev \
zlib1g-dev \
libv8-3.14-dev \
postgresql-client \
texlive-latex-base \
texlive-latex-extra \
texlive-fonts-recommended \
xzdec \
libxml2-dev \
libmagick++-dev \
libx11-dev \
mesa-common-dev \
libglu1-mesa-dev \
unixodbc-dev \
software-properties-common \
build-essential \
protobuf-compiler \
libgsl-dev \
libudunits2-dev \
libgdal-dev \
postgresql-server-dev-all \
vim \
nano \
gawk \
sed \
ccache \
parallel \
cmake

# INSTALL JAVA
RUN export HTTP_PROXY=${net_proxy} &&\
    export HTTPS_PROXY=${net_proxy} &&\
    export http_proxy=${net_proxy} &&\
    export https_proxy=${net_proxy} &&\
    DEBIAN_FRONTEND=noninteractive apt-get update &&\
    DEBIAN_FRONTEND=noninteractive apt-get install --yes openjdk-8-jdk &&\
    DEBIAN_FRONTEND=noninteractive apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

#oracle java, apt-add-repository pulls key but fails to properly import it /o\ - hence the extra apt-key adv
RUN export HTTP_PROXY=${net_proxy} &&\
    export HTTPS_PROXY=${net_proxy} &&\
    export http_proxy=${net_proxy} &&\
    export https_proxy=${net_proxy} &&\
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils \
        software-properties-common\
        debconf-utils\
        gpg\
        gpg-agent && \
    #LC_ALL=C.UTF-8 add-apt-repository --yes -m  ppa:linuxuprising/java && \
    #DEBIAN_FRONTEND=noninteractive apt-key adv  --recv-keys EA8CACC073C3DB2A && \
    #echo 'deb http://ftp.de.debian.org/debian/ stretch-backports main contrib non-free' >/etc/apt/sources.list.d/backports.list && \
    DEBIAN_FRONTEND=noninteractive apt-get update && \
    #echo 'oracle-java11-installer shared/accepted-oracle-license-v1-2 select true' | debconf-set-selections && \
    #DEBIAN_FRONTEND=noninteractive apt-get install --yes -qq oracle-java11-installer\
    #    oracle-java11-set-default &&\
    R CMD javareconf && \
    DEBIAN_FRONTEND=noninteractive apt-get install --yes -qq git &&\
    #-t stretch-backports &&\
    DEBIAN_FRONTEND=noninteractive apt-get clean &&\
    rm -rf /var/lib/apt/lists/*

# Install R packages -----------------------------------------------
#
# - dplyr, ggplot2, tidyr, readr, purrr, stringr, tibble and forcats are shipped with tidyverse
# - AXA based packages are:
# ANAOptimizer qctools TBInterface201710
# quaxa quaxacancelation quaxacancelation2 quaxachurn quaxaclaims quaxaclaimsoccurrence quaxagdv quaddins quaxanbv quaxaoptim quaxasb
# elasticity elasticitytools newbusinesstracker wrthelper
# - Not available for R 3.5.1: AlignAssign, dataaccess, packageInstaller, translations, KnitroR
# - Currently not working: rjags rJava
RUN for pack in abind acepack assertr assertthat AUC\
 backports base base64enc BBmisc BH biglm bindr bindrcpp bit bit64 bitops blob boot brew broom\
 callr car carData caret caTools cellranger checkmate chron class classInt cli clipr cluster coda codetools colorspace compare compiler corrplot covr crayon crosstalk curl CVST \
 data.table datasets DBI dbplyr ddalpha debugme deldir DEoptimR desc devtools DiagrammeR dichromat digest dimRed directlabels doParallel downloader dplyr drat DRR DT daff\
 e1071 effects entropy EnvStats estimability evaluate expm\
 fasttime flextable forcats foreach foreign formatR Formula formula.tools futile.logger futile.options\
 GA gam gbm gdata gdtools geojsonlint geometry geosphere GGally ggplot2 ggrepel ggvis git2r glmnet glmnetUtils glue gmodels gnm goftest gower gplots graphics grDevices grid gridBase gridExtra gsubfn gtable gtools ggridges\
 h2o h2o4gpu haven HDtweedie hexbin highr Hmisc hms htmlTable htmltools htmlwidgets httpuv httr\
 igraph iml influenceR inline ipred irace irlba iterators itertools\
 jqr jsonlite jsonvalidate\
 kernlab KernSmooth kknn knitr\
 labeling lambda.r later lattice latticeExtra lava lazyeval leaflet LearnBayes liqueueR lme4 lmtest lpSolve lubridate\
 magic magrittr manipulateWidget mapproj maps maptools markdown MASS Matching MatchIt Matrix MatrixModels matrixStats maxLik memoise methods mgcv microbenchmark mime miniCRAN miniUI minqa miscTools MLmetrics mlogit mlr mnlogit mnormt ModelMetrics modelr moments multcomp munsell mvtnorm\
 neldermead networkD3 nlme nloptr NMF nnet nortest numDeriv\
 officer openssl openxlsx operator.tools optimbase optimsimplex optmatch optrees osmar\
 packrat pander parallel parallelMap ParamHelpers party pbkrtest pdp pillar pkgconfig pkgmaker plogr plotly plyr pmml pmmlTransformations png polspline polyclip praise prettyunits pROC processx prodlim profvis progress promises proto pryr pscl psych purrr\
 quadprog quantreg qvcalc\
 reticulate R.methodsS3 R.oo R.utils R6 randomForest RANN raster RColorBrewer Rcpp RcppArmadillo RcppEigen RcppRoll RCurl readr readxl recipes registry relimp rematch reprex reshape reshape2 rex rgenoud rgexf rio RJDBC rlang rlist rmarkdown rms rngtools robustbase ROCR RODBC Rook roxygen2 rpart rprojroot RSQLite rstudioapi rvest\
 sandwich sas7bdat satellite scales SDMTools selectr sfsmisc shiny shinyBS shinydashboard shinyjs shinythemes skimr sourcetools sp SparseM spatial SpatialPack spatstat spatstat.data spatstat.utils spData spdep splines splitstackshape sqldf SQUAREM stargazer statar statmod stats stats4 stringdist stringi stringr survey survival svglite\
 tensorflow tcltk TDboost tensor testthat TH.data tibble tictoc tidyr tidyselect tidyverse timeDate timeSeries tinytex tools tsne tweedie\
 utf8 utils uuid\
 V8 viridis viridisLite visNetwork vcd vtreat\
 waterfall waterfalls webshot whisker withr\
 xgboost xlsx XML xml2 xtable\
 yaImpute yaml\
 zip zoo\
 rgl forestFloor geojson gsl mapview odbc protolite QRM tmap tmaptools spatialEco sf RPostgreSQL rmapshaper rgl rgeos rgdal gdalUtils udunits2 units ggmap\
 rpart.plot partykit e1071 MICE Mnet gganmiate ggdendro ggfortify ggthemes ggpubs gggridge gggrepel ggcorrplot ggradar ggiraph gapminder esquisse knitr FactoMineR\
 ; do install2.r -s -e ${pack} >> /install2.r.log 2>> /install2.r.err || : ; done
# Install lightgbm
RUN git clone --recursive https://github.com/Microsoft/LightGBM >> /install2.r.log 2>> /install2.r.err && \
cd LightGBM >> /install2.r.log 2>> /install2.r.err && \
Rscript build_r.R >> /install2.r.log 2>> /install2.r.err || :

# Install some packages directly from github which are not on CRAN yet
#RUN Rscript -e \"library(devtools); install_github('AppliedDataSciencePartners/xgboostExplainer')\" >> /install2.r.log 2>> /install2.r.err || :
EXPOSE 8787
