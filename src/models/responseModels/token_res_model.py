"""
token response model
"""

from pydantic import BaseModel


class TokenResModel(BaseModel):
    """
    token response model
    """

    access_token: str
    token_type: str
