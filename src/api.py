from fastapi import FastAPI
from .controllers.permissionController import router as permission_router
from .controllers.authController import router as auth_router

def register_routes(app: FastAPI):
    app.include_router(permission_router)
    app.include_router(auth_router)
