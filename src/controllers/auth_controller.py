"""
this controller is about login
"""

from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordRequestForm

from ..dependencies.container import get_auth_service
from ..services.interface.i_auth_service import IAuthService
from ..models.responseModels.token_res_model import TokenResModel

router = APIRouter(prefix="/login", tags=["Login"])


@router.post("/login", response_model=TokenResModel)
def login(
    data: OAuth2PasswordRequestForm = Depends(),
    auth_service: IAuthService = Depends(get_auth_service),
):
    """
    login

    Args:
        param1 (OAuth2PasswordRequestForm): user_number and password

    Returns:
        str: token

    Raises:
        if user number or password is error
    """
    token = auth_service.login(data.username, data.password)
    if not token:
        raise HTTPException(status_code=401, detail="Incorrect username or password")

    return token
