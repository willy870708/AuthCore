"""
resources table from database
"""

from sqlalchemy import Column, Integer, String
from ..database.core import Base


class Resources(Base):
    """
    resources table from database
    """

    __tablename__ = "resources"
    id = Column(Integer, primary_key=True, index=True)
    system_id = Column(String)
    resource_name = Column(String)
    resource_identifier = Column(String)
    url = Column(String)
