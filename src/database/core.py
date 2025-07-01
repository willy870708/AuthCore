from typing import Annotated
from fastapi import Depends

from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, Session, declarative_base

import os
from dotenv import load_dotenv

load_dotenv(dotenv_path="src/.env")
DATABASE_URL = os.getenv("DATABASE_URL")

if DATABASE_URL is None:
    raise ValueError("DATABASE_URL environment variable is not set!")

engine = create_engine(DATABASE_URL, pool_size=10, max_overflow=20, echo=True)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

Base = declarative_base()

def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()

DbSession = Annotated[Session, Depends(get_db)]