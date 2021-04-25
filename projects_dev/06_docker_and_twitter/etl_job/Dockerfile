From python:3.8-slim 
#this is an operating system (debian-slim)
#with python 3.6 installed on top!

WORKDIR /app 
#mkdir /app inside the container (and set as default directory?)

#ADD . /app 
#just copy / add over all files into the container's app directory. Better use Copy. no rebuild needed.
COPY requirements.txt /app

RUN pip install --trusted-host pypi.python.org -r requirements.txt

# CMD ["bash"]

CMD ["python", "etl.py"]
