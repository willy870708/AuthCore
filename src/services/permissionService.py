from sqlalchemy import text
from typing import List

from ..models.responseModels.permissionResModel import PermissionResModel
from ..baseService import baseService
from .interface.iPermissionService import IPermissionService
from ..models.requestModels.addPermissionReqModel import addPermissionReqModel

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
    
    def add_permissions(self, reqAddPermissions: List[addPermissionReqModel]) -> int:
        db = self.db
        permissions_data = [(req.role_id, req.resource_id) for req in reqAddPermissions]
        with db.begin() as transaction:
            sql_call_func = text("SELECT PUBLIC.FN_ADD_PERMISSIONS(CAST(:PERMISSIONS_DATA AS PUBLIC.TYPE_PERMISSION_INPUT[]))")
            
            result = db.execute(
                sql_call_func,
                {"PERMISSIONS_DATA": permissions_data}
            )
            
            insert_count = result.scalar_one()
        
        return insert_count