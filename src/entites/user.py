from sqlalchemy import Column, Integer, String, ForeignKey, Boolean
from sqlalchemy.orm import relationship
from ..database.core import Base

class User(Base):
    __tablename__ = "users"
    id = Column(Integer, primary_key=True, index=True)
    user_number = Column(String, unique=True, index=True)
    email = Column(String, unique=True)
    full_name = Column(String)
    is_activate = Column(Boolean)