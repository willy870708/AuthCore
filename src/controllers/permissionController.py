from fastapi import APIRouter, Depends
from ..database.core import DbSession
from typing import Annotated, List

from ..dependencies.container import DependencyContainer
from ..services.interface.iPermissionService import IPermissionService
from ..models.responseModels.PermissionResModel import PermissionResModel
from ..models.requestModels.addPermissionReqModel import addPermissionReqModel

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

@router.post("/add_permission")
def add_permission(
    reqAddPermissions: List[addPermissionReqModel],
    service: Annotated[IPermissionService, Depends(DependencyContainer.get_permission_service)]
    ) -> int:
    return service.add_permissions(reqAddPermissions)