"""
register all api routers
"""

from fastapi import FastAPI
from .controllers.permission_controller import router as permission_router
from .controllers.auth_controller import router as auth_router


def register_routes(app: FastAPI):
    """
    register all api routers

    Args:
        param1 (FastAPI): app

    Returns:


    Raises:

    """
    app.include_router(permission_router)
    app.include_router(auth_router)
