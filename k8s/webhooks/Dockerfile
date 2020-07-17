FROM python:3.8.3-alpine
COPY ./app /app
RUN pip install --upgrade pip && pip install -r /app/requirements.txt

WORKDIR /app
ENTRYPOINT ["python"]
CMD ["main.py"]