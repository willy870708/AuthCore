from sqlalchemy.orm import Session
from sqlalchemy import text
from ..entites.user_role import UserRole
from .models import Permissions

def get_user_permissions(db: Session, user_number: int):
    # Use conn.begin() to ensure that all operations are within a single transaction.
    with db.begin() as transaction:
        cursor_name = "my_permission_cursor"

        sql_call_proc = text("CALL public.get_permission_by_user_id(:user_number, :cursor_name);")
        
        db.execute(
            sql_call_proc,
            {"user_number": user_number, "cursor_name": cursor_name}
        )

        sql_fetch = text(f"FETCH ALL IN \"{cursor_name}\";")
        
        result_proxy = db.execute(sql_fetch)
        rows = result_proxy.fetchall()
        
        results = [Permissions(**dict(zip(result_proxy.keys(), row))) for row in rows]

    return results
