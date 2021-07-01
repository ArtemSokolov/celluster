FROM jefferys/fastpg:latest
RUN pip3 install pandas

COPY . /app
