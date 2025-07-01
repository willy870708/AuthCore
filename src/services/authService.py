from sqlalchemy import text
from datetime import datetime, timedelta
from jose import JWTError, jwt
from passlib.context import CryptContext
from sqlalchemy.orm import Session
from ..entites.user import User
from .interface.iAuthService import IAuthService
from ..models.responseModels.loginResModel import LoginResModel
from ..models.responseModels.tokenResModel import TokenResModel
from dotenv import load_dotenv
import os

load_dotenv(dotenv_path="src/.env")
DATABASE_URL = os.getenv("DATABASE_URL")
SECRET_KEY = os.getenv("SECRET_KEY")
ALGORITHM = os.getenv("ALGORITHM")
ACCESS_TOKEN_EXPIRE_MINUTES = int(os.getenv("ACCESS_TOKEN_EXPIRE_MINUTES"))

pwd_context = CryptContext(schemes=["bcrypt"], deprecated="auto")

class AuthService(IAuthService):
    def __init__(self, db: Session):
        self.db = db

    def login(self, user_number, password) -> TokenResModel:
        db = self.db
        
        sql_call_function = text("SELECT * FROM PUBLIC.FN_GET_USER_PASSWORD(:USER_NUMBER);")
        result = db.execute(
            sql_call_function,
            {"USER_NUMBER": user_number}
        )
        
        login_info = result.first()
        if not login_info:
            return None
        
        login_info_model = LoginResModel(**dict(zip(result.keys(), login_info)))
        
        if not pwd_context.verify(password, login_info_model.hashed_password):
            return None

        access_token_expires = timedelta(minutes=ACCESS_TOKEN_EXPIRE_MINUTES)
        to_encode = {
            "sub": login_info.user_number,
            "exp": datetime.now() + access_token_expires
        }
        encoded_jwt = jwt.encode(to_encode, SECRET_KEY, algorithm=ALGORITHM)
        
        return TokenResModel(access_token=encoded_jwt, token_type="bearer")