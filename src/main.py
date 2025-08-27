"""
main app
"""

import time
import logging
from fastapi import FastAPI, Request
from .api import register_routes
from .logging_config import setup_logging

setup_logging()
logger = logging.getLogger("AuthCore")

app = FastAPI()


@app.middleware("http")
async def log_request(request: Request, call_next):
    "record each http request"
    start_time = time.time()
    response = await call_next(request)
    process_time = time.time() - start_time

    log_message = (
        f"Request: {request.client.host}: {request.client.port}"
        f"- {request.method} {request.url.path}"
        f"Status: {response.status_code}"
        f" Time: {process_time:.4f}s"
    )

    logger.info(log_message)

    return response


register_routes(app)
