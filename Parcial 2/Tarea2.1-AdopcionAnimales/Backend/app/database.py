from sqlalchemy import create_engine
from sqlalchemy.orm import sessionmaker, declarative_base
from app.core.config import *

engine = create_engine(
    DATABASE_URL,
    pool_pre_ping=True,  # Verificar conexión antes de usarla
    echo=False  # Cambiar a True para ver SQL en consola (debug)
)

SessionLocal = sessionmaker(
    autocommit=False,
    autoflush=False,
    bind=engine
)

Base = declarative_base()

# Inyeccion sesiones para fastapi
def get_db():
    db = SessionLocal()
    try:
        yield db
    finally:
        db.close()