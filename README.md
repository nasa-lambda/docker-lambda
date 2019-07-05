# docker-lambda

Code for a docker image providing a jupyter notebook with many useful CMB utilities installed. This Docker image is 
currently in development

# Running LAMBDA Docker Image

1. Install Docker (https://www.docker.com/)
2. Run "docker run -it --rm -p 8888:8888 nasalambda/cmb-notebook"
    a. If you happen to already be using port 8888 for your own Jupyter notebook (or something else),
       change "-p 8888:8888" to "-p XXXX:8888" where XXXX is the port you want to use. This
       instruction maps the local port XXXX to the port 8888 in the Docker container so you
       can access the provided notebook from your web browser.
    b. This command will download the lastest "nasalamba/cmb-notebook" docker image from
       https://hub.docker.com/u/nasalambda/ if you do not have it downloaded.
    c. If there is a newer image online than what you have locally, run the
       command "docker pull nasalambda/cmb-notebook"
3. You should see some output to the terminal where it asks you to copy/paste
   a URL to the browser. If you changed the port in the previous step, change
   the port in the instructions.
    a. On Windows, because of differences in how networking is implemented, you must
       use a different IP address instead of "localhost" in order to access the
       provided Jupyter notebook. Run "docker-machine ip default" and replace
       "localhost" with the output IP address
4. Once you Ctrl-C from the command-line to stop Jupyter and the Docker container, it
   should stop and remove the running Docker container (so you would not be able to
   restart the container with any changes you previously made). If you want to remove
   the downloaded Docker image, you would need to run "docker rmi njmiller/lambda-cmb".
