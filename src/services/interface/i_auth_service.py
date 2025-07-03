"""
auth service interface
"""

from abc import ABC, abstractmethod
from ...models.responseModels.token_res_model import TokenResModel


class IAuthService(ABC):
    """
    auth service interface
    """

    @abstractmethod
    def login(self, user_number, password) -> TokenResModel:
        """
        login

        Args:
            param1 (OAuth2PasswordRequestForm): user_number and password

        Returns:
            str: token

        Raises:
            if user number or password is error
        """
