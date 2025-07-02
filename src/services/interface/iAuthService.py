from abc import ABC, abstractmethod
from ...models.responseModels.tokenResModel import TokenResModel

class IAuthService(ABC):
    @abstractmethod
    def login(self, user_number, password) -> TokenResModel: pass