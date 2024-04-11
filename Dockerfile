FROM jupyter/scipy-notebook:latest 
#FROM lambda-base
#FROM nasalambda/base-notebook

#Installing packages and updating stuff
USER root
RUN apt-get -y update && apt-get install -y gcc gfortran gsl-bin libgsl-dev libcfitsio-bin libcfitsio-dev libfftw3-bin libfftw3-dev git-svn libccfits0v5 libccfits-dev libclhep2.1v5 libclhep-dev libgcc-11-dev cmake vim
RUN pip install --upgrade pip

USER root

#USER $NB_USER

RUN conda update --all
RUN conda install astropy healpy cython emcee

USER $NB_USER

#CMB Analysis Summer School jupyter notebooks
RUN git clone https://github.com/jeffmcm1977/CMBAnalysis_SummerSchool.git $HOME/work/CMBAnalysis_SummerSchool

#LAMBDA code
RUN git clone https://github.com/nasa-lambda/cmb_footprint.git $HOME/.ipython/cmb_footprint
RUN git clone https://github.com/nasa-lambda/cmb_analysis.git $HOME/.ipython/cmb_analysis
RUN cp $HOME/.ipython/cmb_footprint/footprint.cfg $HOME/footprint.cfg

#Installing PyCAMB
RUN git clone https://github.com/cmbant/CAMB.git $HOME/camb --recursive
WORKDIR $HOME/camb/
RUN python setup.py install --user

USER $NB_USER

#CLASS and its python wrapper
RUN git clone https://github.com/lesgourg/class_public.git $HOME/class
WORKDIR $HOME/class
#COPY Makefile_class_py3 $HOME/class/Makefile
#COPY setup_class_py3.py $HOME/class/python/setup.py
RUN make

WORKDIR $HOME/work

#ACTPol Python Likelihood
RUN git clone https://github.com/ACTCollaboration/actpols2_like_py.git $HOME/work/actpols2

#CMB power spectrum plotting
RUN git clone https://github.com/nasa-lambda/cmbpol_plotting.git

#Healpix
#WORKDIR $HOME
##RUN wget https://downloads.sourceforge.net/project/healpix/Healpix_3.31/Healpix_3.31_2016Aug26.tar.gz
#RUN wget https://downloads.sourceforge.net/project/healpix/Healpix_3.82/Healpix_3.82_2022Jul28.tar.gz
#RUN tar -zxvf Healpix_3.82_2022Jul28.tar.gz
#WORKDIR $HOME/Healpix_3.82
#ENV FITSDIR=/usr/lib/aarch64-linux-gnu
#RUN ./configure --auto=all
#RUN make

#Hammurabi
#WORKDIR $HOME
#RUN git svn clone https://svn.code.sf.net/p/hammurabicode/code/trunk hammurabi
#WORKDIR $HOME/hammurabi
#COPY Makefile_hammurabi $HOME/hammurabi/Makefile
#RUN make
#ENV PYTHONPATH $HOME/hammurabi
#RUN cp $HOME/hammurabi/hampy/Hampy_quick-start.ipynb $HOME/work
#RUN cp "$HOME/hammurabi/hampy/Polarized CMB foregrounds.ipynb" $HOME/work/Polarized_CMB_foregrounds.ipynb
#WORKDIR $HOME/hammurabi/hampy
#RUN wget https://downloads.sourceforge.net/project/hammurabicode/supplementary/hampy_test.tgz
#RUN tar -zxvf hampy_test.tgz

#PyGSM
USER root
WORKDIR $HOME
RUN git clone https://github.com/telegraphic/PyGSM
WORKDIR $HOME/PyGSM
RUN python setup.py install
USER $NB_USER

#Cosmosis
#WORKDIR $HOME
#RUN pip install emcee
#RUN git clone http://bitbucket.org/joezuntz/cosmosis
#WORKDIR $HOME/cosmosis
#RUN git clone http://bitbucket.org/joezuntz/cosmosis-standard-library
#WORKDIR $HOME/cosmosis/cosmosis-standard-library
#RUN git checkout
#WORKDIR $HOME/cosmosis
#COPY setup-my-cosmosis $HOME/cosmosis/setup-my-cosmosis
#RUN source setup-my-cosmosis
#RUN make

#BICEP Likelihood
WORKDIR $HOME
COPY b1_hl_likelihood_example.ipynb $HOME/work
COPY bicep1_util.py $HOME/work
#RUN wget http://bicep.rc.fas.harvard.edu/bicep1_3yr/b1_hl_likelihood.tgz
RUN wget https://lambda.gsfc.nasa.gov/data/suborbital/BICEP1/3years/b1_hl_likelihood.tgz
RUN mkdir $HOME/work/b1_hl_likelihood
RUN tar -xvzf b1_hl_likelihood.tgz -C $HOME/work/b1_hl_likelihood

#Copying notebooks to working directory
COPY Introduction.ipynb $HOME/work/
COPY plot_footprints.ipynb $HOME/work/
# RUN cp ~/.ipython/cmb_footprint/examples/plot_footprints.ipynb $HOME/work/

#COPY CAMBDemo.ipynb $HOME/work/
RUN cp $HOME/camb/docs/CAMBdemo.ipynb $HOME/work/

COPY ClassDemo.ipynb $HOME/work/
COPY actpol_likelihood_example.ipynb $HOME/work/

WORKDIR $HOME/work

#COPY sets owner to root so this needs to be changed for files to
#be editable and downloadable
USER root
RUN chown $NB_USER:users Introduction.ipynb plot_footprints.ipynb CAMBdemo.ipynb ClassDemo.ipynb actpol_likelihood_example.ipynb
RUN chown $NB_USER:users b1_hl_likelihood_example.ipynb bicep1_util.py
USER $NB_USER

RUN curl -fsSL https://install.julialang.org | sh -s -- -y
RUN /home/jovyan/.juliaup/bin/julia -e 'using Pkg; Pkg.add("IJulia")'
RUN /home/jovyan/.juliaup/bin/julia -e 'using Pkg; Pkg.add(["Healpix", "Cosmology", "Plots"])'
