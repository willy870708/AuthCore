"""
add permission request model
"""

from pydantic import BaseModel


class AddPermissionReqModel(BaseModel):
    """
    add permission request model
    """

    role_id: int
    resource_id: int
