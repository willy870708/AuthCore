"""
permission table from database
"""

from sqlalchemy import Column, Integer, String, ForeignKey
from ..database.core import Base


class Permission(Base):
    """
    permission table from database
    """

    __tablename__ = "permissions"
    id = Column(Integer, primary_key=True, index=True)
    role_id = Column(String)
    resource_id = Column(Integer, ForeignKey("resources.id"))
