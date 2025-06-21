from fastapi import FastAPI
from .controllers.permissionController import router as permission_router

def register_routes(app: FastAPI):
    app.include_router(permission_router)