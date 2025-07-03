"""
group role table from database
"""

from sqlalchemy import Column, Integer, ForeignKey
from ..database.core import Base


class GroupRole(Base):
    """
    group role table from database
    """

    __tablename__ = "group_roles"
    group_id = Column(Integer, ForeignKey("groups.id"), primary_key=True)
    role_id = Column(Integer, ForeignKey("roles.id"), primary_key=True)
