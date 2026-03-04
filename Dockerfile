FROM python:3.11-slim

RUN useradd -m -u 1000 user

RUN pip install --no-cache-dir \
    torch --index-url https://download.pytorch.org/whl/cpu && \
    pip install --no-cache-dir \
    jupyterlab>=4.0 \
    numpy

WORKDIR /app

COPY torch_judge/ ./torch_judge/
COPY setup.py ./
RUN pip install --no-cache-dir -e .

COPY templates/ ./templates/
COPY solutions/ ./solutions/
COPY entrypoint.sh ./
RUN chmod +x /app/entrypoint.sh

RUN mkdir -p /app/notebooks /app/data && \
    chown -R user:user /app

USER user

ENV PORT=7860
EXPOSE 7860

ENTRYPOINT ["/app/entrypoint.sh"]
