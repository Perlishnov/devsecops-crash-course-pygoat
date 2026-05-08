FROM python:3.11.13-slim-bookworm

WORKDIR /app

ENV PYTHONDONTWRITEBYTECODE=1
ENV PYTHONUNBUFFERED=1
ENV PIP_DISABLE_PIP_VERSION_CHECK=1
ENV PIP_NO_INPUT=1
ENV PIP_PROGRESS_BAR=off

COPY requirements.txt requirements.txt
RUN pip install --no-cache-dir -r requirements.txt gunicorn==23.0.0

COPY . /app/

EXPOSE 8000
CMD ["gunicorn", "--bind", "0.0.0.0:8000", "--workers","6", "pygoat.wsgi"]
