"""
login response model
"""

from pydantic import BaseModel


class LoginResModel(BaseModel):
    """
    login response model
    """

    user_number: str
    hashed_password: str
    email: str
