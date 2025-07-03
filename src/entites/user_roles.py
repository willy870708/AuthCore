"""
user role table from database
"""

from sqlalchemy import Column, Integer, ForeignKey
from ..database.core import Base


class UserRoles(Base):
    __tablename__ = "user_roles"
    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True)
    role_id = Column(Integer, ForeignKey("roles.id"), primary_key=True)
