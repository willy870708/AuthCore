from pydantic import BaseModel

class Permissions(BaseModel):
    id: int
    system_id: int
    resource_name: str
    resource_identifier: str
    description: str | None = None