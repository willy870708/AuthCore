from pydantic import BaseModel

class TokenResModel(BaseModel):
    access_token: str
    token_type: str