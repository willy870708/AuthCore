"""
permission service interface
"""

from abc import ABC, abstractmethod
from typing import List

from ...models.requestModels.permission_req_model import PermissionReqModel
from ...models.responseModels.permission_res_model import PermissionResModel
from ...models.requestModels.add_permission_req_model import AddPermissionReqModel


class IPermissionService(ABC):
    """
    permission service interface
    """

    @abstractmethod
    def get_user_permissions(
        self, permission_req_model: PermissionReqModel
    ) -> List[PermissionResModel]:
        """
        get user's permissions

        Args:
            param1 PermissionReqModel: permission_req_model

        Returns:
            List[PermissionResModel]: list of permission response model

        Raises:

        """

    @abstractmethod
    def add_permissions(self, add_permissions_req: List[AddPermissionReqModel]) -> int:
        """
        add permission

        Args:
            param1 List[AddPermissionReqModel]: list of add permission request model

        Returns:
            int: insert count

        Raises:
            if user number or password is error
        """

    @abstractmethod
    def add_permissions_by_csv(self, file) -> int:
        """
        add permission by csv file

        Args:
            param1 File.file: file

        Returns:
            int: insert count

        Raises:
            if user number or password is error
        """
