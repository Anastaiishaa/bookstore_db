from sqlalchemy import Column, Integer, Text, ForeignKey, VARCHAR, FLOAT, Date, TIMESTAMP
from sqlalchemy import create_engine
from sqlalchemy.orm import declarative_base
from sqlalchemy.orm import sessionmaker


Base = declarative_base()

# маппинг структуры таблиц БД в структуру классов ORM
class Products(Base):
    __tablename__ = 'products'

    product_id = Column(Integer(), primary_key=True)
    book_name = Column(VARCHAR(250))
    author_name = Column(VARCHAR(100))
    genre = Column(Text)
    price = Column(FLOAT)
    points_count = Column(Integer)
    books_count = Column(Integer)

class Supply(Base):
    __tablename__ = 'supply'

    supply_id = Column(Integer, primary_key=True)
    supply_date = Column(Date)
    products_number = Column(Integer)
    product_id = Column(Integer, ForeignKey('products.product_id'))
    supplier_id = Column(Integer, ForeignKey('suppliers.supplier_id'))

class Suppliers(Base):
    __tablename__ = 'suppliers'

    supplier_id = Column(Integer, primary_key=True)
    supplier_name = Column(Text)
    phone = Column(VARCHAR(20))

class Sales(Base):
    __tablename__ = 'sales'

    sale_id = Column(Integer, primary_key=True)
    employee_id = Column(Integer, ForeignKey('employees.employee_id'))
    client_id = Column(Integer, ForeignKey('clients.client_id'))
    sale_date = Column(TIMESTAMP)

class Content(Base):
    __tablename__ = 'content'

    item_id = Column(Integer, primary_key=True)
    sale_id = Column(Integer, ForeignKey('sales.sale_id'))
    product_id = Column(Integer, ForeignKey('products.product_id'))
    products_count = Column(Integer)

class Employees(Base):
    __tablename__ = 'employees'

    employee_id = Column(Integer, primary_key=True)
    employee_full_name = Column(VARCHAR(100))
    position = Column(Text)
    phone = Column(Text)

class Clients(Base):
    __tablename__ = 'clients'

    client_id = Column(Integer, primary_key=True)
    client_name = Column(VARCHAR(100))
    email = Column(Text)
    points_number = Column(Integer)

class Feedbacks(Base):
    __tablename__ = 'feedbacks'

    feedback_id = Column(Integer, primary_key=True)
    client_id = Column(Integer, ForeignKey('clients.client_id'))
    product_id = Column(Integer, ForeignKey('products.product_id'))
    feedback_text = Column(Text)
    rate = Column(Integer)

class SecretData(Base):
    __tablename__ = 'secret_data'

    ID = Column(Integer, primary_key=True)
    username = Column(Text)
    secret_token = Column(Text)

class MainLog(Base):
    __tablename__ = 'main_log'

    log_item_id = Column(Integer, primary_key=True)
    operation_type = Column(Text)
    operation_date = Column(Text)
    user_operator = Column(Text)
    changed_data = Column(Text)

class BookCatalog(Base):
    __tablename__ = 'book_catalog'

    book_name = Column(VARCHAR(250), primary_key=True)
    author_name = Column(VARCHAR(100))
    genre = Column(Text)
    price = Column(FLOAT)
    books_count = Column(Integer)
    supply_date = Column(Date)
    points_count = Column(Integer)

class PurchaseHistory(Base):
    __tablename__ = 'purcahse_history'

    sale_id = Column(Integer, primary_key=True)
    book_name = Column(VARCHAR(250))
    author_name = Column(VARCHAR(100))
    products_count = Column(Integer)
    sale_date = Column(TIMESTAMP)
    price = Column(FLOAT)
    rate = Column(Integer)

class Inventory(Base):
    __tablename__ = 'inventory'

    product_id = Column(Integer, primary_key=True)
    book_name = Column(VARCHAR(250))
    author_name = Column(VARCHAR(100))
    books_count = Column(Integer)
    supply_id = Column(Integer)
    supplier_id = Column(Integer)
    supplier_name = Column(Text)
    supply_date = Column(Date)

class SalesReport(Base):
    __tablename__ = 'sales_report'

    sale_id = Column(Integer, primary_key=True)
    sale_date = Column(TIMESTAMP)
    book_name = Column(VARCHAR(250))
    client_name = Column(VARCHAR(100))
    employee_full_name = Column(VARCHAR(100))

class AnalysisCustomerPreferences(Base):
    __tablename__ = 'analysis_customer_preferences'

    feedback_id = Column(Integer, primary_key=True)
    book_name = Column(VARCHAR(250))
    author_name = Column(VARCHAR(100))
    feedback_text = Column(Text)
    rate = Column(Integer)

# непосредственное подключение к базе данных
# пароль индивидуальной учетки ("admin" для учетки ana_admin,
# "andrey" для учетки Andrey_client, "matveeva" для учетки matveeva_employee)
psw = "rusk"
db = "bookstore"

# вместо ana_admin подставляем любую индивидуальную роль из БД
engine = create_engine('postgresql+psycopg2://postgres:' + psw + '@localhost/' + db)
SessionLocal = sessionmaker(autocommit=False, autoflush=False, bind=engine)

db = SessionLocal()

#query_example = db.query(Products).all()
#for row in query_example:
 #   print(row.product_id, row.book_name, row.author_name)

#newEmployee = Employees(
 #   employee_id = 6524,
  #  employee_full_name = 'Танасков Илья Викторович',
   # position = 'IT-специалист',
    #phone = '8(911)8512637'
#)
#db.add(newEmployee)
#db.commit()

target_spec = db.query(Clients).filter_by(client_name='Елена').first()
target_spec.client_name = 'Анна'
db.commit()