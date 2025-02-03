FROM python:3.8-alpine

WORKDIR /home/p41test

RUN addgroup -S appgroup

RUN adduser -S appuser -G appgroup -h /home -s /sbin/nologin

RUN chown -R appuser:appgroup /home

ENV HOME=/home

WORKDIR /home/appuser/

COPY . /home/appuser

RUN pip install flask --break-system-packages

EXPOSE 5000

EXPOSE 80

USER appuser

CMD ["python", "sts.py"]
