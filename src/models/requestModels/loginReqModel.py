from pydantic import BaseModel

class LoginReqModel(BaseModel):
    user_number: str
    password: str
