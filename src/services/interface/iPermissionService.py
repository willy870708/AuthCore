from abc import ABC, abstractmethod
from typing import List

from ...models.responseModels.permissionResModel import PermissionResModel
from ...models.requestModels.addPermissionReqModel import addPermissionReqModel

class IPermissionService(ABC):
    
    @abstractmethod
    def get_user_permissions(self, user_number: str) -> List[PermissionResModel]: pass
    
    @abstractmethod
    def add_permissions(self, reqAddPermissions: List[addPermissionReqModel]) -> int: pass
    
    @abstractmethod
    def add_permissions_by_csv(self, file) -> int: pass