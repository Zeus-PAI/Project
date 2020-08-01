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
    RegisterViajeLogic,
    calificarviajero,
    ViajeroPedidos,
    PedidoLogic,
    SolicitudPedidos,
    UpdatePedidoLogic,
    ActualizarLogic,
    idUserLogic
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


@app.route("/registrarViajes", methods=["GET", "POST"])
def registrarViajeform():
    if request.method == "GET":
        logic = idViajeroLogic()
        idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        return render_template("registrarViaje.html", idViajero=idViajero)
    else:  # "POST"
        logic = idViajeroLogic()
        idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        fechaInicio = request.form["fechaInicio"]
        fechaRegreso = request.form["fechaRegreso"]
        paisDestino = request.form["paisDestino"]
        direccionEstadia = request.form["direccionEstadia"]
        cobroLibra = request.form["cobroLibra"]
        telefono = request.form["telefono"]
        imagenReferencia = request.form["imagenReferencia"]
        logic = RegisterViajeLogic()
        rows = logic.insertNewViaje(
            idViajero,
            fechaInicio,
            fechaRegreso,
            paisDestino,
            direccionEstadia,
            cobroLibra,
            telefono,
            imagenReferencia,
        )
        message = f"{rows} affected"
        return render_template(
            "registrarViaje.html", message=message, idViajero=idViajero
        )


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
        logic = ConfirmarLogic()
        data = logic.ViajeByid(id)
        idViajero = request.form["idviajero"]
        idViaje = request.form["idviaje"]
        Articulo = request.form["nombre"]
        Precio = request.form["precio"]
        Peso = request.form["peso"]
        Categoria = request.form["categoria"]
        Cantidad = request.form["cantidad"]
        Especificaciones = request.form["descripcion"]
        URL = request.form["url"]
        Pais = request.form["pais"]
        Fecha = request.form["fecharegreso"]
        Total = request.form["total"]
        logic2 = PedidoLogic()
        rows = logic2.insertNewPedido(
            diccionarioUsuarios.get("idUser"),
            idViajero,
            idViaje,
            Articulo,
            Precio,
            Peso,
            Categoria,
            Cantidad,
            Especificaciones,
            URL,
            Pais,
            Fecha,
            Total,
        )
        message = f"{rows} affected"
        return render_template("dashboard_user.html", message=message)


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
        idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        logic2 = ShowViajesViajero()
        data = logic2.ShowViajesViajero(idViajero)
        return render_template("viajesviajeros.html", datos=data, Viajero=idViajero)
    else:  # "POST"
        logic2 = ShowViajesViajero()
        data = logic2.ShowViajesViajero(diccionarioUsuarios.get("idUser"))
        return render_template("viajesviajeros.html", datos=data)


@app.route("/calificarviajero/<int:id>", methods=["GET", "POST"])
def CalificarViajeros(id):
    if request.method == "GET":
        logic = ActualizarLogic()
        data = logic.PedidoByid(id)
        return render_template("calificarviajero.html", datos=data)
    else:  # "POST"
        logic = idUserLogic()
        idV = logic.getidViajeroUsuario(request.form["idUsuarioCalificado"])
        Calificado = int("".join(map(str, idV[0])))
        Calificador = diccionarioUsuarios.get("idUser")
        IdPedido = request.form["idPedido"]
        Nota = request.form["Nota"]
        comentario = request.form["comentario"]
        logic = calificarviajero()
        rows = logic.calificarviajero(
            Calificador, Calificado, IdPedido, Nota, comentario
        )
        message = f"{rows} affected"
        logic2 = UserShowPedidos()
        data = logic2.ShowPedidos(diccionarioUsuarios.get("idUser"))
        return render_template("ver_pedidos.html", message=message, datos=data)


@app.route("/pedidosViajero", methods=["GET", "POST"])
def ShowPedidosViajero():
    if request.method == "GET":
        logic = idViajeroLogic()
        idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        logic2 = ViajeroPedidos()
        data = logic2.ShowPedidosViajero(idViajero)
        return render_template("pedidosViajero.html", datos=data)
    else:  # "POST"
        idPedido = request.form["idpedido"]
        Estado = request.form["estado"]
        clase = UpdatePedidoLogic()
        clase.UpdatePedido(idPedido, Estado)
        logic = idViajeroLogic()
        idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        logic2 = ViajeroPedidos()
        data = logic2.ShowPedidosViajero(idViajero)
        return render_template("pedidosViajero.html", datos=data)


@app.route("/solicitudpedidosViajero", methods=["GET", "POST"])
def ShowSolicitudPedidos():
    if request.method == "GET":
        logic = idViajeroLogic()
        idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        logic2 = SolicitudPedidos()
        data = logic2.SolicitudPedidos(idViajero)
        return render_template("solicitudes_pedidos.html", datos=data)
    else:  # "POST"
        idSolicitudPedido = request.form["idsolicitud"]
        Estado = request.form["estadop"]
        clase = UpdatePedidoLogic()
        clase.UpdatePedido(idSolicitudPedido, Estado)
        logic = idViajeroLogic()
        idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        logic2 = SolicitudPedidos()
        data = logic2.SolicitudPedidos(idViajero)
        return render_template("dashboard_viajero.html", datos=data)


@app.route("/pedidosUsuario/<int:id>", methods=["GET", "POST"])
def ActualizarPedido(id):
    if request.method == "GET":
        logic = ActualizarLogic()
        data = logic.PedidoByid(id)
        return render_template(
            "ActualizarPedido.html",
            datos=data,
            id=id,
            user=diccionarioUsuarios.get("idUser"),
        )
    else:
        idPedido = request.form["idpedido"]
        Estado = request.form["estado"]
        clase = UpdatePedidoLogic()
        clase.UpdatePedido(idPedido, Estado)
        logic2 = UserShowPedidos()
        data = logic2.ShowPedidos(diccionarioUsuarios.get("idUser"))
        return render_template("ver_pedidos.html", datos=data)


if __name__ == "__main__":
    app.run(debug=True)
    # app.run(debug=True)
