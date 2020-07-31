from flask import Flask, render_template, request, redirect, session
from MethodUtil import MethodUtil
from userlogic import (
    UserLogic,
    RegisterLogic,
    RequestLogic,
    EstadoLogic,
    GetRequests,
    ViajesLogic,
    UserShowLogic,
    DeleteUser,
    ConfirmarLogic,
    idViajeroLogic,
    UserShowPedidos,
    ViajerosShowAdminLogic,
    PedidosShowAdminLogic,
    ShowViajesViajero,
)
from userobj import UserObj
from Solicitudobj import SolicitudObj
from werkzeug.security import generate_password_hash, check_password_hash

# PASOS PARA AGREGAR AL REPOSITORIO
# git add -A
# git commit -m "nombre de accion"
# git push --set-upstream https://github.com/Zeus-PAI/Project master
app = Flask(__name__)
app.secret_key = "python es bien chivo"
diccionarioUsuarios = {"idUser": "", "User": "", "Nombre": ""}


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
                    diccionarioUsuarios.update({"idUser": userdata.id})
                    diccionarioUsuarios.update({"User": userdata.user})
                    diccionarioUsuarios.update({"Nombre": userdata.name})
                    return render_template(
                        "dashboard_admin.html",
                        userdata=userdata.user,
                        userid=userdata.id,
                    )
                elif userdata.Tipo == 2:
                    diccionarioUsuarios.update({"idUser": userdata.id})
                    diccionarioUsuarios.update({"User": userdata.user})
                    diccionarioUsuarios.update({"Nombre": userdata.name})
                    return render_template(
                        "dashboard_user.html",
                        userdata=userdata.user,
                        userid=userdata.id,
                    )
                elif userdata.Tipo == 3:
                    diccionarioUsuarios.update({"idUser": userdata.id})
                    diccionarioUsuarios.update({"User": userdata.user})
                    diccionarioUsuarios.update({"Nombre": userdata.name})
                    return render_template(
                        "dashboard_viajero.html",
                        userdata=userdata.user,
                        userid=userdata.id,
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
        Foto = request.form["foto"]
        logic = RegisterLogic()
        rows = logic.insertNewUser(
            usuario, nombre, email, contraseña, Fecha, telefono, pais, Foto
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
            usuario,
            nombre,
            email,
            contraseña,
            Fecha,
            telefono,
            Motivos,
            Frecuencia,
            pais,
            Foto,
        )
        message = f"{rows} affected"
        return render_template("RegisterViajero.html", message=message)


@app.route("/solicitudes", methods=["GET", "POST"])
def ShowRequests():
    if request.method == "GET":
        logic2 = GetRequests()
        data = logic2.GetRequests()
        return render_template("solicitudes.html", datos=data)
    else:  # "POST"
        idSolicitud = request.form["idsolicitud"]
        Estado = request.form["estado"]
        logic = EstadoLogic()
        rows = logic.UpdateRequest(idSolicitud, Estado)
        message = f"{rows} affected"
        logic2 = GetRequests()
        data = logic2.GetRequests()
        return render_template("solicitudes.html", message=message, datos=data)


@app.route("/deleteuser", methods=["GET", "POST"])
def DelUsers():
    if request.method == "GET":
        logic2 = UserShowLogic()
        data = logic2.ShowUsers()
        return render_template("deleteuser.html", datos=data)
    else:  # "POST"
        idUsuario = request.form["idUsuario"]
        logic = DeleteUser()
        rows = logic.DeleteUser(idUsuario)
        message = f"{rows} affected"
        logic2 = UserShowLogic()
        data = logic2.ShowUsers()
        return render_template("deleteuser.html", message=message, datos=data)


@app.route("/viajesactivos", methods=["GET", "POST"])
def ShowTrips():
    if request.method == "GET":
        return render_template("Buscarviajes.html")
    else:  # "POST"
        FechaInicio = request.form["fechainicio"]
        FechaFinal = request.form["fechafinal"]
        logic = ViajesLogic()
        datos = logic.GetViajes(FechaInicio, FechaFinal)
        return render_template("ViajesDisponibles.html", datos=datos)


@app.route("/confirmarpedido/<int:id>", methods=["GET", "POST"])
def ConfirmarPedido(id):
    if request.method == "GET":
        logic = ConfirmarLogic()
        data = logic.ViajeByid(id)
        return render_template(
            "ConfirmarPedido.html",
            datos=data,
            id=id,
            user=diccionarioUsuarios.get("idUser"),
        )
    else:  # "POST"
        return render_template("ConfirmarPedido.html")


@app.route("/pedidosUsuario", methods=["GET", "POST"])
def ShowPedidos2():
    if request.method == "GET":
        logic2 = UserShowPedidos()
        data = logic2.ShowPedidos(diccionarioUsuarios.get("idUser"))
        return render_template("ver_pedidos.html", datos=data)
    else:  # "POST"
        logic2 = UserShowPedidos()
        data = logic2.ShowPedidos(diccionarioUsuarios.get("idUser"))
        return render_template("ver_pedidos.html", datos=data)


@app.route("/verviajeros", methods=["GET", "POST"])
def ShowViajeros():
    if request.method == "GET":
        logic2 = ViajerosShowAdminLogic()
        data = logic2.ShowViajerosAdmin()
        return render_template("viajerosadmin.html", datos=data)
    else:  # "POST"
        logic2 = ViajerosShowAdminLogic()
        data = logic2.ShowViajerosAdmin()
        return render_template("viajerosadmin.html", datos=data)


@app.route("/verpedidos", methods=["GET", "POST"])
def ShowTodosLosPedidosAdmin():
    if request.method == "GET":
        logic2 = PedidosShowAdminLogic()
        data = logic2.ShowPedidosAdmin()
        return render_template("pedidosadmin.html", datos=data)
    else:  # "POST"
        logic2 = PedidosShowAdminLogic()
        data = logic2.ShowPedidosAdmin()
        return render_template("pedidosadmin.html", datos=data)


@app.route("/viajesViajero", methods=["GET", "POST"])
def ShowViajesViajeros():
    if request.method == "GET":
        logic = idViajeroLogic()
        idViajero = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        logic2 = ShowViajesViajero()
        data = logic2.ShowViajesViajero(idViajero)
        return render_template("viajesviajeros.html", datos=data)
    else:  # "POST"
        logic2 = ShowViajesViajero()
        data = logic2.ShowViajesViajero(idViajero)
        return render_template("viajesviajeros.html", datos=data)


if __name__ == "__main__":
    app.run(debug=True)
    # app.run(debug=True)
