from sqlalchemy import text
from typing import List

from ..models.responseModels.PermissionResModel import PermissionResModel
from ..baseService import baseService
from ..services.interface.permissionService import IPermissionService

class PermissionService(baseService, IPermissionService):

    def get_user_permissions(self, user_number: str) -> List[PermissionResModel]:
        db = self.db

        with db.begin() as transaction:
            sql_call_func = text("SELECT * FROM PUBLIC.FN_GET_PERMISSION_BY_USER_ID(:USER_NUMBER);")

            result = db.execute(
                sql_call_func,
                {"USER_NUMBER": user_number}
            )

            rows = result.fetchall()
            results = [PermissionResModel(**dict(zip(result.keys(), row))) for row in rows]

        return results