from abc import ABC, abstractmethod
from typing import List

from ..models.responseModels.PermissionResModel import PermissionResModel

class IPermissionService(ABC):
    
    @abstractmethod
    def get_user_permissions(self, user_number: str) -> List[PermissionResModel]: pass