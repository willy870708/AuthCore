"""
groups table from database
"""

from sqlalchemy import Column, Integer, String
from ..database.core import Base


class Groups(Base):
    """
    groups table from database
    """

    __tablename__ = "groups"
    id = Column(Integer, primary_key=True, index=True)
    group_name = Column(String)
    description = Column(String)
