"""
login request model
"""

from pydantic import BaseModel


class LoginReqModel(BaseModel):
    """
    login request model
    """

    user_number: str
    password: str
