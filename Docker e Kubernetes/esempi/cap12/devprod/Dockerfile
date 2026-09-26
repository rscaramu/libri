FROM python:3.12-slim AS base
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt

FROM base AS dev
RUN pip install --no-cache-dir pytest==8.3.3
CMD ["flask", "--app", "app", "run", "--host", "0.0.0.0", \
     "--port", "8000", "--debug"]

FROM base AS prod
RUN useradd -r -d /app app
COPY --chown=app:app app.py .
USER app
CMD ["python", "app.py"]
