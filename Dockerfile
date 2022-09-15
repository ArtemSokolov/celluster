FROM jefferys/fastpg:3.13_latest
RUN pip3 install pandas

COPY . /app
