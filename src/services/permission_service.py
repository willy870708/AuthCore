"""
permission service
"""

from typing import List
from sqlalchemy import text
from sqlalchemy.exc import IntegrityError
import pandas as pd

from ..models.responseModels.permission_res_model import PermissionResModel
from ..base_service import BaseService
from .interface.i_permission_service import IPermissionService
from ..models.requestModels.add_permission_req_model import AddPermissionReqModel


class PermissionService(BaseService, IPermissionService):
    """
    permission service
    """

    def get_user_permissions(self, user_number: str) -> List[PermissionResModel]:

        sql_call_func = text(
            "SELECT * FROM PUBLIC.FN_GET_PERMISSION_BY_USER_ID(:USER_NUMBER);"
        )

        result = self.db.execute(sql_call_func, {"USER_NUMBER": user_number})

        rows = result.fetchall()
        results = [PermissionResModel(**dict(zip(result.keys(), row))) for row in rows]

        return results

    def add_permissions(self, add_permissions_req: List[AddPermissionReqModel]) -> int:
        permissions_data = [
            (req.role_id, req.resource_id) for req in add_permissions_req
        ]

        with self.db.begin():
            sql_call_func = text(
                """
                SELECT PUBLIC.FN_ADD_PERMISSIONS(
                    CAST(:PERMISSIONS_DATA AS PUBLIC.TYPE_PERMISSION_INPUT[])
                )
                """
            )

            result = self.db.execute(
                sql_call_func, {"PERMISSIONS_DATA": permissions_data}
            )

            insert_count = result.scalar_one()

        return insert_count

    def add_permissions_by_csv(self, file) -> int:
        total_add_count = 0
        chunk_size = 1000

        for chunck_df in pd.read_csv(file, chunksize=chunk_size, encoding="utf-8"):
            permission_list: List[AddPermissionReqModel] = []
            try:
                for _, row in chunck_df.iterrows():
                    permission = AddPermissionReqModel(
                        role_id=row.get("role_id"), resource_id=row.get("resource_id")
                    )
                    permission_list.append(permission)

                total_add_count += self.add_permissions(permission_list)

            except IntegrityError as e:
                print(
                    f"failed: processing error in chunk:{total_add_count}, message: {e}"
                )
                continue

        return total_add_count
