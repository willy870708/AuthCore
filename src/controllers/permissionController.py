from fastapi import APIRouter, Depends
from ..database.core import DbSession
from typing import Annotated, List

from ..dependencies.container import DependencyContainer
from ..dependencies.interface import IPermissionService
from ..models.responseModels.PermissionResModel import PermissionResModel


router = APIRouter(
    prefix="/permission",
    tags=["Permission"] 
)

@router.get("/get_permission/{user_number}")
def get_user_permission(
        user_number: str,
        service: Annotated[IPermissionService, Depends(DependencyContainer.get_permission_service)]
    ) -> List[PermissionResModel]:
    
    return service.get_user_permissions(user_number)