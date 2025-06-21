from typing import Annotated
from fastapi import Depends
from sqlalchemy.orm import Session

from ..database.core import get_db, DbSession
from ..services.permissionService import PermissionService
from .interface import IPermissionService


class DependencyContainer:
    
    @staticmethod
    def get_permission_service(db: DbSession) -> IPermissionService:
        return PermissionService(db)