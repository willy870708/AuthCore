"""
users table from database
"""

from sqlalchemy import Column, Integer, String, Boolean
from ..database.core import Base


class Users(Base):
    """
    users table from database
    """

    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    user_number = Column(String, unique=True, index=True)
    email = Column(String, unique=True)
    full_name = Column(String)
    is_activate = Column(Boolean)
