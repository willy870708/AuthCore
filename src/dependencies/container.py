"""
dependency container
"""

from fastapi import Depends, HTTPException, status
from fastapi.security import OAuth2PasswordBearer

from jose import jwt
from jose.exceptions import ExpiredSignatureError

from ..database.core import DbSession
from ..services.permission_service import PermissionService
from ..services.interface.i_permission_service import IPermissionService
from ..services.auth_service import AuthService, SECRET_KEY, ALGORITHM
from ..services.interface.i_auth_service import IAuthService

oauth2_scheme = OAuth2PasswordBearer(tokenUrl="login/login")


def get_permission_service(db: DbSession) -> IPermissionService:
    """
    get permission service

    Args:
        param1 (DbSession): db session

    Returns:
        IPermissionService: Permission Service interface

    Raises:

    """
    return PermissionService(db)


def get_auth_service(db: DbSession) -> IAuthService:
    """
    get auth service

    Args:
        param1 (DbSession): db session

    Returns:
        IAuthService: Auth Service interface

    Raises:

    """
    return AuthService(db)


def get_current_user(token: str = Depends(oauth2_scheme)):
    """
    get current user

    Args:
        param1 (str): token from oauth2 scheme

    Returns:
        IAuthService: user number

    Raises:
        401 Could not validate credentials
    """
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

    except ExpiredSignatureError as exc:
        raise HTTPException(
            status_code=status.HTTP_401_UNAUTHORIZED,
            detail="Token Expired",
            headers={"WWW-Authenticate": "Bearer"},
        ) from exc

    return user_number
