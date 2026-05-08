FROM python:3.11.13-slim-bookworm

# set work directory
WORKDIR /app


# Avoid broken APT post-invoke cleanup hook seen in some slim variants
RUN rm -f /etc/apt/apt.conf.d/docker-clean

# Runtime/build dependencies
RUN apt-get update && apt-get install --no-install-recommends -y \
    build-essential \
    dnsutils \
    libpq-dev \
  && rm -rf /var/lib/apt/lists/*

# Set environment variables
ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1


# Install dependencies
RUN python -m pip install --no-cache-dir pip==25.0
COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt gunicorn==23.0.0


# copy project
COPY . /app/


# install pygoat
EXPOSE 8000

WORKDIR /app
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers","6", "pygoat.wsgi"]
