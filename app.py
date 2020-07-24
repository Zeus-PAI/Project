from flask import Flask, render_template, request, redirect, session
from MethodUtil import MethodUtil
from userlogic import UserLogic, RegisterLogic, RequestLogic
from userobj import UserObj
from Solicitudobj import SolicitudObj
from werkzeug.security import generate_password_hash, check_password_hash


app = Flask(__name__)
app.secret_key = "python es bien chivo"


@app.route("/")
def index():
    return render_template("index.html")


@app.route("/loginform", methods=MethodUtil.list_ALL())
def loginform():
    if request.method == "GET":
        return render_template("loginform.html", message="")
    if request.method == "POST":
        user = request.form["user"]
        password = request.form["password"]
        print(password)
        print(generate_password_hash(password))
        print(
            check_password_hash(
                "pbkdf2:sha256:150000$Q5PULnGV$bdc51198ad18432f00fea6a5cb59bec4d7977cb28d3e7ef575bab3b93bfa9628",
                "12345",
            )
        )
        logic = UserLogic()
        userdata = logic.getUserData(user)
        # session["user"] = userdata
        if userdata is not None:
            if userdata.password == password:
                if userdata.Tipo == 1:
                    return render_template(
                        "dashboard_admin.html", userdata=userdata.user
                    )
                elif userdata.Tipo == 2:
                    return render_template(
                        "dashboard_user.html", userdata=userdata.user
                    )
                elif userdata.Tipo == 3:
                    return render_template(
                        "dashboard_viajero.html", userdata=userdata.user
                    )
            else:
                return render_template("loginform.html", message="hubo error")
        else:
            return render_template("loginform.html", message="hubo error")


@app.route("/registrousuario", methods=["GET", "POST"])
def registerform():
    if request.method == "GET":
        return render_template("RegisterUser.html")
    else:  # "POST"
        usuario = request.form["usuario"]
        nombre = request.form["nombre"]
        email = request.form["correo"]
        contraseña = request.form["contraseña"]
        Fecha = request.form["fecha"]
        telefono = request.form["telefono"]
        pais = request.form["pais"]
        logic = RegisterLogic()
        rows = logic.insertNewUser(
            usuario, nombre, email, contraseña, Fecha, telefono, pais
        )
        message = f"{rows} affected"
        return render_template("RegisterUser.html", message=message)


@app.route("/registroviajero", methods=["GET", "POST"])
def registerviajeroform():
    if request.method == "GET":
        return render_template("RegisterViajero.html")
    else:  # "POST"
        usuario = request.form["usuario"]
        nombre = request.form["nombre"]
        email = request.form["correo"]
        contraseña = request.form["contraseña"]
        Fecha = request.form["fecha"]
        telefono = request.form["telefono"]
        pais = request.form["pais"]
        Motivos = request.form["motivos"]
        Frecuencia = request.form["frecuencia"]
        Foto = request.form["foto"]
        logic = RequestLogic()
        rows = logic.NewRequest(
            usuario, nombre, email, contraseña, Fecha, telefono, Motivos, Frecuencia, pais, Foto
        )
        message = f"{rows} affected"
        return render_template("RegisterViajero.html", message=message)


if __name__ == "__main__":
    app.run(debug=True)
    # app.run(debug=True)
