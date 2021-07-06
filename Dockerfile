FROM jefferys/fastpg:latest
RUN pip3 install pandas
RUN pip3 install scanpy

COPY . /app
