"""
this controller is about permission management
"""

from typing import Annotated, List
from fastapi import APIRouter, Depends, UploadFile, File, HTTPException, status


from ..dependencies.container import get_permission_service, get_current_user
from ..services.interface.i_permission_service import IPermissionService
from ..models.requestModels.permission_req_model import PermissionReqModel
from ..models.responseModels.permission_res_model import PermissionResModel
from ..models.requestModels.add_permission_req_model import AddPermissionReqModel

router = APIRouter(prefix="/permission", tags=["Permission"])


"""
get user permission
"""


@router.post("/get_permission")
def get_user_permission(
    permission_req_model: PermissionReqModel,
    service: Annotated[IPermissionService, Depends(get_permission_service)],
    _: str = Depends(get_current_user),
) -> List[PermissionResModel]:
    """
    get user permission

    Args:
        param1 PermissionReqModel: permission_req_model

    Returns:
        list[PermissionResModel]: permissions list

    Raises:

    """
    return service.get_user_permissions(permission_req_model)


@router.post("/add_permission")
def add_permission(
    req_add_permissions: List[AddPermissionReqModel],
    service: Annotated[IPermissionService, Depends(get_permission_service)],
    _: str = Depends(get_current_user),
) -> int:
    """
    add permission

    Args:
        param1 (str): permission list

    Returns:
        int: insert count

    Raises:

    """
    return service.add_permissions(req_add_permissions)


@router.post("add_permission_by_csv")
async def add_permission_csv(
    service: Annotated[IPermissionService, Depends(get_permission_service)],
    _: str = Depends(get_current_user),
    file: UploadFile = File(...),
) -> int:
    """
    add permission by csv

    Args:
        param1 (file): csv file

    Returns:
        int: insert count

    Raises:
        if file is not csv, raise 400 bad request
    """
    if not file.filename.endswith(".csv"):
        raise HTTPException(
            status_code=status.HTTP_400_BAD_REQUEST,
            detail="only allow to upload csv file",
        )

    add_count = service.add_permissions_by_csv(file.file)

    return add_count
