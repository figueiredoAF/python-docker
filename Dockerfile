FROM python:3.8-slim-buster

# Instructs Docker to use this path as the default location for all subsequent commands.
WORKDIR /app

# Install dependencies
COPY requirements.txt requirements.txt
RUN pip3 install -r requirements.txt

# Install app files
COPY *.py .

# Tell Docker what command to run when the image is executed inside a container
CMD [ "python3", "-m", "flask", "run", "--host=0.0.0.0" ]