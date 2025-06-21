from pydantic import BaseModel

class PermissionResModel(BaseModel):
    resource_id: int
    system_id: int
    resource_name: str
    resource_identifier: str
    description: str | None = None