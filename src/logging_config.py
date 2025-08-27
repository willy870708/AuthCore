import logging.config
import os
from datetime import datetime


def setup_logging():
    """setup logging"""

    logs_dir = "D:/app/logs"
    if not os.path.exists(logs_dir):
        os.makedirs(logs_dir)

    log_filename = datetime.now().strftime("AuthCore_%Y-%m-%d.log")
    log_filepath = os.path.join(logs_dir, log_filename)

    logging_config = {
        "version": 1,
        "formatters": {
            "standard": {
                "format": "%(asctime)s - %(name)s - %(levelname)s - %(message)s"
            }
        },
        "handlers": {
            "file": {
                "class": "logging.handlers.RotatingFileHandler",
                "formatter": "standard",
                "filename": log_filepath,
                "maxBytes": 1024 * 1024 * 500,  # 500MB
                "backupCount": 5,
            },
            "console": {"class": "logging.StreamHandler", "formatter": "standard"},
        },
        "loggers": {
            "AuthCore": {
                "handlers": ["file", "console"],
                "level": "INFO",
                "propagate": False,
            }
        },
    }

    logging.config.dictConfig(logging_config)
