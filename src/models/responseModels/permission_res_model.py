"""
permission response model
"""

from datetime import datetime
from pydantic import BaseModel


class PermissionResModel(BaseModel):
    """
    permission response model
    """

    resource_id: int
    system_id: int
    resource_name: str
    resource_identifier: str
    description: str | None = None
    granted_at: datetime
