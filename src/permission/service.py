from sqlalchemy.orm import Session
from ..entites.user_role import UserRole

def get_user_permissions(db: Session, user_id: int):
    role_id_tuples = db.query(UserRole.role_id).filter(UserRole.user_id == user_id).all()
    roles = [role_tuple[0] for role_tuple in role_id_tuples]
    return roles

def check_permission(db: Session, user_id: int, required_permission: str):
    permissions = get_user_permissions(db, user_id)
    return required_permission in permissions
