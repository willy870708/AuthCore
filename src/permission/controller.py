from fastapi import APIRouter
from ..database.core import DbSession

from . import service

router = APIRouter(
    prefix="/permission",
    tags=["Permission"] 
)

@router.get("/get_permission/{user_id}")
def get_user_permission(user_id: int, db: DbSession):
    return service.get_user_permissions(db, user_id)

