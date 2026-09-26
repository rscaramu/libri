FROM python:3.12-slim
RUN groupadd -r app && useradd -r -g app -d /app app
WORKDIR /app
COPY --chown=app:app requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY --chown=app:app app.py .
USER app
EXPOSE 8000
CMD ["python", "app.py"]
