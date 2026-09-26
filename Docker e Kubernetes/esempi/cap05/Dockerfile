FROM python:3.12-slim
COPY graceful.py /graceful.py
STOPSIGNAL SIGTERM
HEALTHCHECK --interval=10s --timeout=3s --retries=3 \
  CMD ["python", "-c", "import os,sys; sys.exit(0 if os.path.exists('/tmp/ok') else 1)"]
CMD ["python", "/graceful.py"]
