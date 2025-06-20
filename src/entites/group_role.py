from sqlalchemy import Column, Integer, String, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from ..database.core import Base

class GroupRole(Base):
    __tablename__ = "group_roles"
    group_id = Column(Integer, ForeignKey("groups.id"), primary_key=True)
    role_id = Column(Integer, ForeignKey("roles.id"), primary_key=True)