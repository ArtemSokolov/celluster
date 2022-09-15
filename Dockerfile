FROM jefferys/fastpg:3.13_latest

RUN apt-get update && \
    apt-get install -y python3-pip

RUN pip3 install pandas

COPY . /app
