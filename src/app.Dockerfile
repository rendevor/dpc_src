FROM python:3.10

WORKDIR /usr/src/app

COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

COPY hello.py .

ENV FLASK_APP=hello
ENV FLASK_DEBUG=1

EXPOSE 5000
ENTRYPOINT [ "python3", "-m", "flask", "run", "-h", "0.0.0.0" ]
