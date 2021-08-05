FROM jefferys/fastpg:3.10_latest
RUN pip3 install pandas

COPY . /app
