from pydantic import BaseModel

class LoginResModel(BaseModel):
    user_number: str
    hashed_password: str
    email: str