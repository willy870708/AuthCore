from fastapi import APIRouter, Depends, UploadFile, File, HTTPException, status
from typing import Annotated, List
import pandas as pd
import io

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

@router.post("add_permission_by_csv")
async def add_permission_csv(
    service: Annotated[IPermissionService, Depends(get_permission_service)],
    current_user: str = Depends(get_current_user),
    file: UploadFile = File(...)
    ) -> int:
    
    if not file.filename.endswith(".csv"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="only allow to upload csv file"
        )
    
    add_count = service.add_permissions_by_csv(file.file)
    
    return add_count