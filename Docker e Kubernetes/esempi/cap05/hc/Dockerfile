FROM python:3.12-slim
WORKDIR /app
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt
COPY app.py .
EXPOSE 8000
HEALTHCHECK --interval=15s --timeout=3s \
  --start-period=5s --retries=3 \
  CMD python -c "import urllib.request as u; \
  u.urlopen('http://localhost:8000/')" || exit 1
CMD ["python", "app.py"]
