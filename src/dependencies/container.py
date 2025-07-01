from typing import Annotated
from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer

from jose import JWTError, jwt
from jose.exceptions import ExpiredSignatureError

from ..database.core import get_db, DbSession
from ..services.permissionService import PermissionService
from ..services.interface.iPermissionService import IPermissionService
from ..services.authService import AuthService, SECRET_KEY, ALGORITHM
from ..services.interface.iAuthService import IAuthService

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login/login")

def get_permission_service(db: DbSession) -> IPermissionService:
    return PermissionService(db)

def get_auth_service(db: DbSession) -> IAuthService:
    return AuthService(db)

def get_current_user(token: str = Depends(oauth2_scheme)):
    credentials_exception = HTTPException(
        status_code=status.HTTP_401_UNAUTHORIZED,
        detail="Could not validate credentials",
        headers={"WWW-Authenticate": "Bearer"},
    )
    try:
        payload = jwt.decode(token, SECRET_KEY, algorithms=[ALGORITHM])
        user_number: str = payload.get("sub")
        if user_number is None:
            raise credentials_exception
    
    except ExpiredSignatureError:
            raise HTTPException(
                status_code=status.HTTP_401_UNAUTHORIZED,
                detail="Token Expired",
                headers={"WWW-Authenticate": "Bearer"},
            )
    
    return user_number