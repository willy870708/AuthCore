from pydantic import BaseModel

class addPermissionReqModel(BaseModel):
    role_id: int
    resource_id: int