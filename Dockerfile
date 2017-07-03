FROM jupyter/scipy-notebook 

#Installing packages and updating stuff
USER root
RUN apt-get -y update && apt-get install -y gcc gfortran
RUN pip install --upgrade pip

#So running python2 from command line runs the miniconda python2
RUN ln -s $CONDA_DIR/envs/python2/bin/python $CONDA_DIR/bin/python2

USER $NB_USER

RUN conda install astropy healpy cython
RUN conda install -n python2 astropy healpy cython

#CMB Analysis Summer School jupyter notebooks
RUN git clone https://github.com/jeffmcm1977/CMBAnalysis_SummerSchool.git /home/jovyan/work/CMBAnalysis_SummerSchool

#LAMBDA code
RUN git clone https://github.com/nasa-lambda/cmb_footprint.git /home/jovyan/.ipython/cmb_footprint
RUN git clone https://github.com/nasa-lambda/cmb_analysis.git /home/jovyan/.ipython/cmb_analysis
RUN cp /home/jovyan/.ipython/cmb_footprint/footprint.cfg /home/jovyan/footprint.cfg

USER root
#Installing CAMB and copying the Python demo to local directory
RUN pip install --egg camb
RUN pip2 install --egg camb

USER $NB_USER

#CLASS and its python wrapper
RUN git clone https://github.com/lesgourg/class_public.git /home/jovyan/class
WORKDIR /home/jovyan/class
COPY Makefile_class /home/jovyan/class/Makefile
RUN make
RUN make clean
COPY Makefile_class_py3 /home/jovyan/class/Makefile
COPY setup_class_py3.py /home/jovyan/class/python/setup.py
RUN make

WORKDIR /home/jovyan/work

#ACTPol Python Likelihood
RUN git clone https://github.com/ACTCollaboration/actpols2_like_py.git /home/jovyan/work/actpols2

#CMB power spectrum plotting
RUN git clone https://github.com/nasa-lambda/cmbpol_plotting.git

#Copying notebooks to working directory
COPY Introduction.ipynb /home/jovyan/work/
COPY plot_footprints.ipynb /home/jovyan/work/
COPY CAMBDemo.ipynb /home/jovyan/work
COPY ClassDemo.ipynb /home/jovyan/work
COPY actpol_likelihood_example_v4.ipynb /home/jovyan/work

#COPY sets owner to root so this needs to be changed for files to
#be editable and downloadable
USER root
RUN chown $NB_USER:users Introduction.ipynb plot_footprints.ipynb CAMBDemo.ipynb ClassDemo.ipynb actpol_likelihood_example_v4.ipynb
USER $NB_USER
