from flask import Flask, render_template, request, url_for, redirect
from flask_sqlalchemy import SQLAlchemy
from flask_login import LoginManager, UserMixin, login_user, logout_user
import enum
from sqlalchemy import Enum

psw = "rusk"
db_name = "bookstore"

app = Flask(__name__)
app.config["SQLALCHEMY_DATABASE_URI"] = 'postgresql+psycopg2://postgres:' + psw + '@localhost/' + db_name
app.config["SECRET_KEY"] = "abc"
app.debug = True
db = SQLAlchemy()

login_manager = LoginManager()
login_manager.init_app(app)


class MyRoles(enum.Enum):
    client = "client"
    employee = "employee"
    admin = "admin"

class Users(UserMixin, db.Model):
	id = db.Column(db.Integer, primary_key=True)
	username = db.Column(db.String(250), unique=True, nullable=False)
	password = db.Column(db.String(250), nullable=False)
	role = db.Column(Enum(MyRoles))


db.init_app(app)

roles_distr = {
	"client": ['book_catalog', 'purchase_history'],
	"employee": ['inventory', 'sales_report', 'analysis_customer_preferences'],
	"admin": [
		'main_log', 'secret_data', 'clients', 'content', 'employees', 'feedbacks',
        'products', 'sales', 'suppliers', 'supply', 'analysis_customer_preferences',
        'book_catalog', 'inventory', 'purchase_history', 'sales_report'
	]
}

with app.app_context():
	db.create_all()


@login_manager.user_loader
def loader_user(user_id):
	return Users.query.get(user_id)


@app.route('/register', methods=["GET", "POST"])
def register():
	if request.method == "POST":
		user = Users(
			username=request.form.get("username"),
			password=request.form.get("password"),
			role=request.form.get("role")
		)
		db.session.add(user)
		db.session.commit()
		return redirect(url_for("login"))
	return render_template("sign_up.html")


@app.route("/login", methods=["GET", "POST"])
def login():
	if request.method == "POST":
		user = Users.query.filter_by(
			username=request.form.get("username")).first()
		if user.password == request.form.get("password"):
			login_user(user)
			return redirect(url_for("home"))
	return render_template("login.html")


@app.route("/logout")
def logout():
	logout_user()
	return redirect(url_for("home"))


@app.route("/")
def home():
	return render_template("home.html", roles_distr=roles_distr)

@app.route("/main_log")
def main_log():
	return render_template("main_log.html")


@app.route("/secret_data")
def secret_data():
	return render_template("secret_data.html")

@app.route("/clients")
def clients():
	return render_template("clients.html")

@app.route("/content")
def content():
	return render_template("content.html")

@app.route("/employees")
def employees():
	return render_template("employees.html")

@app.route("/feedbacks")
def feedbacks():
	return render_template("feedbacks.html")

@app.route("/products")
def products():
	return render_template("products.html")

@app.route("/sales")
def sales():
	return render_template("sales.html")

@app.route("/suppliers")
def suppliers():
	return render_template("suppliers.html")

@app.route("/supply")
def supply():
	return render_template("supply.html")

@app.route("/analysis_customer_prefences")
def analysis_customer_preferences():
	return render_template("analysis_customer_preferences.html")

@app.route("/book_ctalog")
def book_catalog():
	return render_template("book_catalog.html")

@app.route("/inventory")
def inventory():
	return render_template("inventory.html")

@app.route("/purchase_history")
def purchase_history():
	return render_template("purchase_history.html")

@app.route("/sales_report")
def sales_report():
	return render_template("sales_report.html")

if __name__ == "__main__":
	app.run()