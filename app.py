import os
import urllib.request
from flask import Flask, flash, request, redirect, url_for, render_template, session
from werkzeug.utils import secure_filename
from MethodUtil import MethodUtil
from datetime import date
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
    idUserLogic,
    DisponibilidadViajero,
    PerfilUsuario,
    PerfilViajero,
    NotasViajero,
    ViajesDispViajero,
    UserShowFacturas,
    AdminShowFacturas,
    AdminShowCalificaciones,
    UpdatePerfil,
    UpdatePerfilViajero,
    ViajesAdminLogic,
)
from userobj import UserObj
from Solicitudobj import SolicitudObj
from werkzeug.security import generate_password_hash, check_password_hash

# PASOS PARA AGREGAR AL REPOSITORIO
# git add -A
# git commit -m "nombre de accion"
# git push --set-upstream https://github.com/Zeus-PAI/Project master
# Excelente texto
app = Flask(__name__)
app.secret_key = "python es bien chivo"
diccionarioUsuarios = {"idUser": "", "User": "", "Nombre": "", "Pais": "", "Foto": ""}

UPLOAD_FOLDER = "static/uploads/"
app.config["UPLOAD_FOLDER"] = UPLOAD_FOLDER
app.config["MAX_CONTENT_LENGTH"] = 16 * 1024 * 1024

ALLOWED_EXTENSIONS = set(["png", "jpg", "jpeg", "gif"])


def allowed_file(filename):
    return "." in filename and filename.rsplit(".", 1)[1].lower() in ALLOWED_EXTENSIONS


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
                    diccionarioUsuarios.update({"Pais": userdata.country})
                    diccionarioUsuarios.update({"Foto": userdata.Foto})
                    return render_template(
                        "dashboard_admin.html",
                        userdata=userdata.user,
                        userid=userdata.id,
                        userfoto=userdata.Foto,
                    )
                elif userdata.Tipo == 2:
                    diccionarioUsuarios.update({"idUser": userdata.id})
                    diccionarioUsuarios.update({"User": userdata.user})
                    diccionarioUsuarios.update({"Nombre": userdata.name})
                    diccionarioUsuarios.update({"Pais": userdata.country})
                    diccionarioUsuarios.update({"Foto": userdata.Foto})
                    return render_template(
                        "dashboard_user.html",
                        userdata=userdata.user,
                        userid=userdata.id,
                        userfoto=userdata.Foto,
                    )
                elif userdata.Tipo == 3:
                    diccionarioUsuarios.update({"idUser": userdata.id})
                    diccionarioUsuarios.update({"User": userdata.user})
                    diccionarioUsuarios.update({"Nombre": userdata.name})
                    diccionarioUsuarios.update({"Pais": userdata.country})
                    diccionarioUsuarios.update({"Foto": userdata.Foto})
                    return render_template(
                        "dashboard_viajero.html",
                        userdata=userdata.user,
                        userid=userdata.id,
                        userfoto=userdata.Foto,
                    )
            else:
                return render_template(
                    "loginform.html", message="Usuario o contraseña incorrectos"
                )
        else:
            return render_template(
                "loginform.html", message="Usuario o contraseña incorrectos"
            )


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
        Foto = ""

        print(f"request.files -> {request.files}")
        if "file" not in request.files:
            flash("No file part")
            print(request.url)
            return redirect(request.url)
        file = request.files["file"]
        print(f"file.filename -> {file.filename}")
        if file.filename == "":
            flash("No image selected for uploading")
            logic = RegisterLogic()
            rows = logic.insertNewUser(
                usuario, nombre, email, contraseña, Fecha, telefono, pais, Foto
            )
            return render_template("mensajeUsuario.html")
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
            flash("Image successfully uploaded and displayed")
            Foto = file.filename
            logic = RegisterLogic()
            rows = logic.insertNewUser(
                usuario, nombre, email, contraseña, Fecha, telefono, pais, Foto
            )
            return render_template("mensajeUsuario.html")
        else:
            flash("Allowed image types are -> png, jpg, jpeg, gif")
            return redirect(request.url)
        message = f"{rows} affected"
    return render_template("mensajeUsuario.html", message=message)


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
        Foto = ""

        print(f"request.files -> {request.files}")
        if "file" not in request.files:
            flash("No file part")
            print(request.url)
            return redirect(request.url)
        file = request.files["file"]
        print(f"file.filename -> {file.filename}")
        if file.filename == "":
            flash("No image selected for uploading")
            return redirect(request.url)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
            flash("Image successfully uploaded and displayed")
            Foto = file.filename
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
        else:
            flash("Allowed image types are -> png, jpg, jpeg, gif")
            return render_template("index.html")
    message = f"{rows} affected"
    return render_template("mensajeViajero.html", message=message)


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
        imagenReferencia = ""

        print(f"request.files -> {request.files}")
        if "file" not in request.files:
            flash("No file part")
            print(request.url)
            return redirect(request.url)
        file = request.files["file"]
        print(f"file.filename -> {file.filename}")
        if file.filename == "":
            flash("No image selected for uploading")
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
            return render_template(
                "dashboard_viajero.html",
                userdata=diccionarioUsuarios.get("User"),
                userfoto=diccionarioUsuarios.get("Foto"),
            )
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
            flash("Image successfully uploaded and displayed")
            imagenReferencia = file.filename
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
        else:
            flash("Allowed image types are -> png, jpg, jpeg, gif")
            return render_template(
                "dashboard_viajero.html",
                userdata=diccionarioUsuarios.get("User"),
                userfoto=diccionarioUsuarios.get("Foto"),
            )
        message = f"{rows} affected"
        return render_template(
            "dashboard_viajero.html",
            userdata=diccionarioUsuarios.get("User"),
            userfoto=diccionarioUsuarios.get("Foto"),
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
        idUsuario = request.form["idusuario"]
        logic = DeleteUser()
        rows = logic.DeleteUser(idUsuario)
        message = f"{rows} affected"
        logic2 = UserShowLogic()
        data = logic2.ShowUsers()
        return render_template("deleteuser.html", message=message, datos=data)


@app.route("/viajesactivos", methods=["GET", "POST"])
def ShowTrips():
    if request.method == "GET":
        PaisOrigen = diccionarioUsuarios.get("Pais")
        return render_template("Buscarviajes.html", PaisOrigen=PaisOrigen)
    else:  # "POST"
        FechaInicio = request.form["fechainicio"]
        FechaFinal = request.form["fechafinal"]
        PaisOrigen = diccionarioUsuarios.get("Pais")
        logic = ViajesLogic()
        datos = logic.GetViajes(FechaInicio, FechaFinal, PaisOrigen)
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
            username=diccionarioUsuarios.get("User"),
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
        FechaPedido = date.today()
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
            FechaPedido,
            Fecha,
            Total,
        )
        message = f"{rows} affected"
        Foto = diccionarioUsuarios.get("Foto")
        return render_template(
            "mensajePedido.html", message=message, userfoto=Foto, FechaEntrega=Fecha
        )


@app.route("/pedidosUsuario", methods=["GET", "POST"])
def ShowPedidos2():
    if request.method == "GET":
        logic2 = UserShowPedidos()
        data = logic2.ShowPedidos(diccionarioUsuarios.get("idUser"))
        User = diccionarioUsuarios.get("User")
        return render_template("ver_pedidos.html", datos=data, User=User)
    else:  # "POST"
        logic2 = UserShowPedidos()
        data = logic2.ShowPedidos(diccionarioUsuarios.get("idUser"))
        User = diccionarioUsuarios.get("User")
        return render_template("ver_pedidos.html", datos=data, User=User)


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
        idPedido = request.form["idpedido"]
        Estado = request.form["estado"]
        clase = UpdatePedidoLogic()
        clase.UpdatePedido(idPedido, Estado)
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
        idViaje = request.form["idviaje"]
        Estado = request.form["estado"]
        logic = DisponibilidadViajero()
        logic.DisponibilidadViajero(idViaje, Estado)
        logic3 = idViajeroLogic()
        idV = logic3.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        logic2 = ShowViajesViajero()
        data = logic2.ShowViajesViajero(idViajero)
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
        User = diccionarioUsuarios.get("User")
        return render_template(
            "ver_pedidos.html", message=message, datos=data, User=User
        )


@app.route("/calificarusuario/<int:id>", methods=["GET", "POST"])
def CalificarUsuarios(id):
    if request.method == "GET":
        logic = ActualizarLogic()
        data = logic.PedidoByid(id)
        return render_template("calificarusuario.html", datos=data)
    else:  # "POST"
        Calificado = request.form["idUsuarioCalificado"]
        Calificador = diccionarioUsuarios.get("idUser")
        IdPedido = request.form["idPedido"]
        Nota = request.form["Nota"]
        comentario = request.form["comentario"]
        logic = calificarviajero()
        rows = logic.calificarviajero(
            Calificador, Calificado, IdPedido, Nota, comentario
        )
        logic3 = idViajeroLogic()
        idV = logic3.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        logic2 = ViajeroPedidos()
        data = logic2.ShowPedidosViajero(idViajero)
        return render_template("pedidosViajero.html", datos=data, idViajero=idViajero)


@app.route("/pedidosViajero", methods=["GET", "POST"])
def ShowPedidosViajero():
    if request.method == "GET":
        logic = idViajeroLogic()
        idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        logic2 = ViajeroPedidos()
        data = logic2.ShowPedidosViajero(idViajero)
        return render_template("pedidosViajero.html", datos=data, idViajero=idViajero)
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
        return render_template("pedidosViajero.html", datos=data, idViajero=idViajero)


@app.route("/solicitudpedidosViajero", methods=["GET", "POST"])
def ShowSolicitudPedidos():
    if request.method == "GET":
        logic = idViajeroLogic()
        idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        logic2 = SolicitudPedidos()
        data = logic2.SolicitudPedidos(idViajero)
        return render_template(
            "solicitudes_pedidos.html", datos=data, idViajero=idViajero
        )
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
        return render_template(
            "solicitudes_pedidos", datos=data, idViajero=idViajero
        )


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


@app.route("/perfilUsuario", methods=["GET", "POST"])
def ShowPerfilUsuario():
    if request.method == "GET":
        logic = PerfilUsuario()
        data = logic.getPerfilUsuario(diccionarioUsuarios.get("idUser"))
        logic3 = NotasViajero()
        Notas = logic3.getNotasViajero(diccionarioUsuarios.get("idUser"))
        return render_template("perfilUsuario.html", datos=data, Notas=Notas)
    else:  # "POST"
        logic = PerfilUsuario()
        data = logic.getPerfilUsuario(diccionarioUsuarios.get("idUser"))
        logic3 = NotasViajero()
        Notas = logic3.getNotasViajero(diccionarioUsuarios.get("idUser"))
        return render_template("perfilUsuario.html", datos=data, Notas=Notas)


@app.route("/perfilViajero", methods=["GET", "POST"])
def ShowPerfilViajero():
    if request.method == "GET":
        logic = idViajeroLogic()
        idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        logic2 = PerfilViajero()
        data = logic2.getPerfilViajero(idViajero)
        logic3 = NotasViajero()
        Notas = logic3.getNotasViajero(diccionarioUsuarios.get("idUser"))
        logic4 = ShowViajesViajero()
        viajes = logic4.ShowViajesViajero(idViajero)
        logic5 = ViajeroPedidos()
        pedidos = logic5.ShowPedidosViajero(idViajero)
        logic6 = ViajesDispViajero()
        viajesDisponibles = logic6.ShowViajesDisp(idViajero)
        return render_template(
            "perfilViajero.html",
            datos=data,
            Notas=Notas,
            Viajes=viajes,
            Pedidos=pedidos,
            Activos=viajesDisponibles,
        )
    else:  # "POST"
        logic = idViajeroLogic()
        idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        logic2 = PerfilViajero()
        data = logic2.getPerfilViajero(idViajero)
        logic3 = NotasViajero()
        Notas = logic3.getNotasViajero(diccionarioUsuarios.get("idUser"))
        logic4 = ShowViajesViajero()
        viajes = logic4.ShowViajesViajero(idViajero)
        logic5 = ViajeroPedidos()
        pedidos = logic5.ShowPedidosViajero(idViajero)
        logic6 = ViajesDispViajero()
        viajesDisponibles = logic6.ShowViajesDisp(idViajero)
        return render_template(
            "perfilViajero.html",
            datos=data,
            Notas=Notas,
            Viajes=viajes,
            Pedidos=pedidos,
            Activos=viajesDisponibles,
        )


@app.route("/perfilViajero/<int:id>", methods=["GET", "POST"])
def ShowPerfilViajero2(id):
    if request.method == "GET":
        logic = idViajeroLogic()
        idV = logic.getidViajero(id)
        idViajero = int("".join(map(str, idV[0])))
        logic2 = PerfilViajero()
        data = logic2.getPerfilViajero(idViajero)
        logic3 = NotasViajero()
        Notas = logic3.getNotasViajero(id)
        logic4 = ShowViajesViajero()
        viajes = logic4.ShowViajesViajero(idViajero)
        logic5 = ViajeroPedidos()
        pedidos = logic5.ShowPedidosViajero(idViajero)
        logic6 = ViajesDispViajero()
        viajesDisponibles = logic6.ShowViajesDisp(idViajero)
        return render_template(
            "perfilViajero2.html",
            datos=data,
            Notas=Notas,
            Viajes=viajes,
            Pedidos=pedidos,
            Activos=viajesDisponibles,
        )
    else:  # "POST"
        logic = idViajeroLogic()
        idV = logic.getidViajero(id)
        idViajero = int("".join(map(str, idV[0])))
        logic2 = PerfilViajero()
        data = logic2.getPerfilViajero(idViajero)
        logic3 = NotasViajero()
        Notas = logic3.getNotasViajero(id)
        logic4 = ShowViajesViajero()
        viajes = logic4.ShowViajesViajero(idViajero)
        logic5 = ViajeroPedidos()
        pedidos = logic5.ShowPedidosViajero(idViajero)
        logic6 = ViajesDispViajero()
        viajesDisponibles = logic6.ShowViajesDisp(idViajero)
        return render_template(
            "perfilViajero2.html",
            datos=data,
            Notas=Notas,
            Viajes=viajes,
            Pedidos=pedidos,
            Activos=viajesDisponibles,
        )


@app.route("/FacturasUsuario", methods=["GET", "POST"])
def ShowFacturas():
    if request.method == "GET":
        logic2 = UserShowFacturas()
        data = logic2.ShowFacturas(diccionarioUsuarios.get("idUser"))
        User = diccionarioUsuarios.get("User")
        return render_template("ver_facturas.html", datos=data, User=User)
    else:  # "POST"
        logic2 = UserShowFacturas()
        data = logic2.ShowFacturas(diccionarioUsuarios.get("idUser"))
        User = diccionarioUsuarios.get("User")
        return render_template("ver_facturas.html", datos=data, User=User)


@app.route("/FacturasUsuario/<int:id>/<int:idUsuario>", methods=["GET", "POST"])
def FacturaPedido(id, idUsuario):
    if request.method == "GET":
        logic = ActualizarLogic()
        data = logic.PedidoByid(id)
        logic2 = PerfilUsuario()
        dataUser = logic2.getPerfilUsuario(idUsuario)
        return render_template(
            "FacturaPedido.html",
            datos=data,
            id=id,
            user=diccionarioUsuarios.get("idUser"),
            nombre=diccionarioUsuarios.get("Nombre"),
            dataUser=dataUser,
        )
    else:
        logic = ActualizarLogic()
        data = logic.PedidoByid(id)
        logic2 = PerfilUsuario()
        dataUser = logic2.getPerfilUsuario(idUsuario)
        return render_template(
            "FacturaPedido.html",
            datos=data,
            id=id,
            user=diccionarioUsuarios.get("idUser"),
            nombre=diccionarioUsuarios.get("Nombre"),
            dataUser=dataUser,
        )


@app.route("/verFacturas", methods=["GET", "POST"])
def ShowAdminFacturas():
    if request.method == "GET":
        logic2 = AdminShowFacturas()
        data = logic2.ShowAllFacturas()
        User = diccionarioUsuarios.get("User")
        return render_template("facturas.html", datos=data, User=User)
    else:  # "POST"
        logic2 = AdminShowFacturas()
        data = logic2.ShowAllFacturas()
        User = diccionarioUsuarios.get("User")
        return render_template("facturas.html", datos=data, User=User)


@app.route("/verCalificaciones", methods=["GET", "POST"])
def ShowAdminNotas():
    if request.method == "GET":
        logic2 = AdminShowCalificaciones()
        data = logic2.ShowAllNotas()
        return render_template("calificaciones.html", datos=data)
    else:  # "POST"
        logic2 = AdminShowCalificaciones()
        data = logic2.ShowAllNotas()
        return render_template("calificaciones.html", datos=data)


@app.route("/editarPerfil", methods=["GET", "POST"])
def EditarPerfil():
    if request.method == "GET":
        profile = PerfilUsuario()
        data = profile.getPerfilUsuario(diccionarioUsuarios.get("idUser"))
        return render_template("editarPerfil.html", datos=data)
    else:  # "POST"
        Usuario = request.form["usuario"]
        Correo = request.form["correo"]
        Password = request.form["password"]
        Telefono = request.form["telefono"]
        Pais = request.form["pais"]
        Foto = ""

        print(f"request.files -> {request.files}")
        if "file" not in request.files:
            flash("No file part")
            print(request.url)
            return redirect(request.url)
        file = request.files["file"]
        print(f"file.filename -> {file.filename}")
        if file.filename == "":
            flash("No image selected for uploading")
            editar = UpdatePerfilViajero()

            editar.UpdatePerfilViajero(
                diccionarioUsuarios.get("idUser"),
                Usuario,
                Correo,
                Password,
                Telefono,
                Pais,
                diccionarioUsuarios.get("Foto"),
            )
            diccionarioUsuarios.update({"Pais": Pais})
            diccionarioUsuarios.update({"User": Usuario})
            logic = idViajeroLogic()
            idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
            idViajero = int("".join(map(str, idV[0])))
            logic2 = PerfilViajero()
            data = logic2.getPerfilViajero(idViajero)
            logic3 = NotasViajero()
            Notas = logic3.getNotasViajero(diccionarioUsuarios.get("idUser"))
            logic4 = ShowViajesViajero()
            viajes = logic4.ShowViajesViajero(idViajero)
            logic5 = ViajeroPedidos()
            pedidos = logic5.ShowPedidosViajero(idViajero)
            logic6 = ViajesDispViajero()
            viajesDisponibles = logic6.ShowViajesDisp(idViajero)

            return render_template(
                "perfilViajero.html",
                datos=data,
                Notas=Notas,
                Viajes=viajes,
                Pedidos=pedidos,
                Activos=viajesDisponibles,
            )
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
            flash("Image successfully uploaded and displayed")
            Foto = file.filename
            editar = UpdatePerfilViajero()
            editar.UpdatePerfilViajero(
                diccionarioUsuarios.get("idUser"),
                Usuario,
                Correo,
                Password,
                Telefono,
                Pais,
                Foto,
            )
            diccionarioUsuarios.update({"Foto": Foto})
            diccionarioUsuarios.update({"Pais": Pais})
            diccionarioUsuarios.update({"User": Usuario})

        else:
            flash("Allowed image types are -> png, jpg, jpeg, gif")
            return redirect(request.url)
        logic = idViajeroLogic()
        idV = logic.getidViajero(diccionarioUsuarios.get("idUser"))
        idViajero = int("".join(map(str, idV[0])))
        logic2 = PerfilViajero()
        data = logic2.getPerfilViajero(idViajero)
        logic3 = NotasViajero()
        Notas = logic3.getNotasViajero(diccionarioUsuarios.get("idUser"))
        logic4 = ShowViajesViajero()
        viajes = logic4.ShowViajesViajero(idViajero)
        logic5 = ViajeroPedidos()
        pedidos = logic5.ShowPedidosViajero(idViajero)
        logic6 = ViajesDispViajero()
        viajesDisponibles = logic6.ShowViajesDisp(idViajero)
        return render_template(
            "perfilViajero.html",
            datos=data,
            Notas=Notas,
            Viajes=viajes,
            Pedidos=pedidos,
            Activos=viajesDisponibles,
        )


@app.route("/perfilUsuario/<int:id>", methods=["GET", "POST"])
def ShowPerfilUsuario2(id):
    if request.method == "GET":
        profile = PerfilUsuario()
        data = profile.getPerfilUsuario(id)
        logic3 = NotasViajero()
        Notas = logic3.getNotasViajero(id)
        return render_template("perfilUsuario2.html", datos=data, Notas=Notas)
    else:  # "POST"
        profile = PerfilUsuario()
        data = profile.getPerfilUsuario(diccionarioUsuarios.get("idUser"))
        logic3 = NotasViajero()
        Notas = logic3.getNotasViajero(diccionarioUsuarios.get("idUser"))
        return render_template("perfilUsuario2.html", datos=data, Notas=Notas)


@app.route("/editarPerfilUsuario", methods=["GET", "POST"])
def EditarPerfilUsuario():
    if request.method == "GET":
        profile = PerfilUsuario()
        data = profile.getPerfilUsuario(diccionarioUsuarios.get("idUser"))
        return render_template("editarPerfilUsuario.html", datos=data)
    else:  # "POST"
        Usuario = request.form["usuario"]
        Correo = request.form["correo"]
        Password = request.form["password"]
        Telefono = request.form["telefono"]
        Pais = request.form["pais"]
        Foto = ""

        print(f"request.files -> {request.files}")
        if "file" not in request.files:
            flash("No file part")
            print(request.url)
            return redirect(request.url)
        file = request.files["file"]
        print(f"file.filename -> {file.filename}")
        if file.filename == "":
            flash("No image selected for uploading")
            editar = UpdatePerfil()
            editar.UpdatePerfil(
                diccionarioUsuarios.get("idUser"),
                Usuario,
                Correo,
                Password,
                Telefono,
                Pais,
                diccionarioUsuarios.get("Foto"),
            )
            diccionarioUsuarios.update({"Pais": Pais})
            diccionarioUsuarios.update({"User": Usuario})
            profile = PerfilUsuario()
            data = profile.getPerfilUsuario(diccionarioUsuarios.get("idUser"))
            logic3 = NotasViajero()
            Notas = logic3.getNotasViajero(diccionarioUsuarios.get("idUser"))
            return render_template("perfilUsuario.html", datos=data, Notas=Notas)
        if file and allowed_file(file.filename):
            filename = secure_filename(file.filename)
            file.save(os.path.join(app.config["UPLOAD_FOLDER"], filename))
            flash("Image successfully uploaded and displayed")
            Foto = file.filename
            editar = UpdatePerfil()
            editar.UpdatePerfil(
                diccionarioUsuarios.get("idUser"),
                Usuario,
                Correo,
                Password,
                Telefono,
                Pais,
                Foto,
            )
            diccionarioUsuarios.update({"Foto": Foto})
            diccionarioUsuarios.update({"Pais": Pais})
            diccionarioUsuarios.update({"User": Usuario})
        else:
            flash("Allowed image types are -> png, jpg, jpeg, gif")
            return redirect(request.url)
        profile = PerfilUsuario()
        data = profile.getPerfilUsuario(diccionarioUsuarios.get("idUser"))
        logic3 = NotasViajero()
        Notas = logic3.getNotasViajero(diccionarioUsuarios.get("idUser"))
        return render_template("perfilUsuario.html", datos=data, Notas=Notas)


@app.route("/perfilViajero2/<int:id>", methods=["GET", "POST"])
def ShowPerfilViajero3(id):
    if request.method == "GET":
        logic = idUserLogic()
        idV = logic.getidViajeroUsuario(id)
        idViajero = int("".join(map(str, idV[0])))
        logic2 = PerfilViajero()
        data = logic2.getPerfilViajero(id)
        logic3 = NotasViajero()
        Notas = logic3.getNotasViajero(idViajero)
        logic4 = ShowViajesViajero()
        viajes = logic4.ShowViajesViajero(id)
        logic5 = ViajeroPedidos()
        pedidos = logic5.ShowPedidosViajero(id)
        logic6 = ViajesDispViajero()
        viajesDisponibles = logic6.ShowViajesDisp(id)
        return render_template(
            "perfilViajero2.html",
            datos=data,
            Notas=Notas,
            Viajes=viajes,
            Pedidos=pedidos,
            Activos=viajesDisponibles,
        )
    else:  # "POST"
        logic = idUserLogic()
        idV = logic.getidViajeroUsuario(id)
        idViajero = int("".join(map(str, idV[0])))
        logic2 = PerfilViajero()
        data = logic2.getPerfilViajero(id)
        logic3 = NotasViajero()
        Notas = logic3.getNotasViajero(idViajero)
        logic4 = ShowViajesViajero()
        viajes = logic4.ShowViajesViajero(id)
        logic5 = ViajeroPedidos()
        pedidos = logic5.ShowPedidosViajero(id)
        logic6 = ViajesDispViajero()
        viajesDisponibles = logic6.ShowViajesDisp(id)
        return render_template(
            "perfilViajero2.html",
            datos=data,
            Notas=Notas,
            Viajes=viajes,
            Pedidos=pedidos,
            # Muy buen texto
            Activos=viajesDisponibles,
        )


@app.route("/homeUsuario")
def homeUser():
    return render_template(
        "dashboard_user.html",
        userdata=diccionarioUsuarios.get("User"),
        userfoto=diccionarioUsuarios.get("Foto"),
    )


@app.route("/homeViajero")
def homeViajero():
    return render_template(
        "dashboard_viajero.html",
        userdata=diccionarioUsuarios.get("User"),
        userfoto=diccionarioUsuarios.get("Foto"),
    )


@app.route("/homeAdmin")
def homeAdmin():
    return render_template(
        "dashboard_admin.html",
        userdata=diccionarioUsuarios.get("User"),
        userfoto=diccionarioUsuarios.get("Foto"),
    )


@app.route("/verviajes", methods=["GET", "POST"])
def ShowTodosLosViajesAdmin():
    if request.method == "GET":
        logic2 = ViajesAdminLogic()
        data = logic2.GetViajesAdmin()
        return render_template("viajesadmin.html", datos=data)
    else:  # "POST"
        logic2 = ViajesAdminLogic()
        data = logic2.GetViajesAdmin()
        return render_template("viajesadmin.html", datos=data)


if __name__ == "__main__":
    app.run(debug=True)
    # app.run(debug=True)
