from fastapi import APIRouter, Depends
from typing import Annotated, List

from ..dependencies.container import get_permission_service, get_current_user
from ..services.interface.iPermissionService import IPermissionService
from ..models.responseModels.permissionResModel import PermissionResModel
from ..models.requestModels.addPermissionReqModel import addPermissionReqModel

router = APIRouter(
    prefix="/permission",
    tags=["Permission"] 
)

@router.get("/get_permission/{user_number}")
def get_user_permission(
        user_number: str,
        service: Annotated[IPermissionService, Depends(get_permission_service)],
        current_user: str = Depends(get_current_user)
    ) -> List[PermissionResModel]:
    
    return service.get_user_permissions(user_number)

@router.post("/add_permission")
def add_permission(
    reqAddPermissions: List[addPermissionReqModel],
    service: Annotated[IPermissionService, Depends(get_permission_service)],
    current_user: str = Depends(get_current_user)
    ) -> int:
    return service.add_permissions(reqAddPermissions)