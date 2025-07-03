"""
base service
"""

from typing import Annotated
from fastapi import Depends

from sqlalchemy.orm import Session
from .database.core import get_db


class BaseService:
    """
    base service
    """

    def __init__(self, db: Annotated[Session, Depends(get_db)]):
        self.db = db
