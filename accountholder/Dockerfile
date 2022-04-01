FROM python:3.9-slim-bullseye

EXPOSE 8080
USER root

WORKDIR /app

COPY requirements.txt /app/

RUN pip install -r requirements.txt

COPY *.py /app/
COPY accountholder.ini /app/

CMD ["python", "accountholder.py"]
#CMD ["uwsgi", "--ini", "accountholder.ini"]  # requires much larger non-slim base image

