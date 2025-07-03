"""
user group table from database
"""

from sqlalchemy import Column, Integer, ForeignKey
from ..database.core import Base


class UserGroups(Base):
    """
    user group table from database
    """

    __tablename__ = "user_groups"
    user_id = Column(Integer, ForeignKey("users.id"), primary_key=True)
    group_id = Column(Integer, ForeignKey("groups.id"), primary_key=True)
