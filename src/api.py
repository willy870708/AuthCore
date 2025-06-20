from fastapi import FastAPI
from src.permission.controller import router as permission_router

def register_routes(app: FastAPI):
    app.include_router(permission_router)