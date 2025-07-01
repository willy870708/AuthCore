from fastapi import APIRouter, Depends, HTTPException
from fastapi.security import OAuth2PasswordRequestForm

from ..dependencies.container import get_auth_service
from ..services.interface.iAuthService import IAuthService
from ..models.responseModels.tokenResModel import TokenResModel

router = APIRouter(
    prefix="/login",
    tags=["Login"] 
)

@router.post("/login", response_model=TokenResModel)
def login(data: OAuth2PasswordRequestForm = Depends(), auth_service: IAuthService = Depends(get_auth_service)):

    token = auth_service.login(data.username, data.password)
    if not token:
        raise HTTPException(status_code=401, detail="Incorrect username or password")
    
    return token
