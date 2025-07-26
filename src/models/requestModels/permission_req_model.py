"""
permission request model
"""

from typing import Optional
from pydantic import BaseModel


class PermissionReqModel(BaseModel):
    """
    permission request model
    """

    user_number: str
    granted_start_date: Optional[str] = None
    granted_end_date: Optional[str] = None
    system_id: int
    page_no: int = 1
    page_size: int = 10
