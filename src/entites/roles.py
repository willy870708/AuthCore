"""
roles table from database
"""

from sqlalchemy import Column, Integer, String
from ..database.core import Base


class Roles(Base):
    """
    roles table from database
    """

    __tablename__ = "roles"
    id = Column(Integer, primary_key=True, index=True)
    system_id = Column(String)
    role_name = Column(String, index=True)
    description = Column(String)
