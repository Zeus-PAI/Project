from Logic import Logic
from userobj import UserObj
from Solicitudobj import SolicitudObj


class UserLogic(Logic):
    def __init__(self):
        super().__init__()
        self.keys = [
            "idUsuario",
            "Usuario",
            "nombre_completo",
            "correo",
            "contraseña",
            "FechaNacimiento",
            "telefono",
            "pais",
            "idTipo",
            "Foto",
        ]

    def getUserData(self, user):
        database = self.get_databaseXObj()
        sql = f"select * from proyectozeus.usuarios where Usuario='{user}';"
        data = database.executeQuery(sql)
        data = self.tupleToDictionaryList(data, self.keys)
        if len(data) > 0:
            data_dic = data[0]
            userObj = UserObj(
                data_dic["idUsuario"],
                data_dic["Usuario"],
                data_dic["nombre_completo"],
                data_dic["correo"],
                data_dic["contraseña"],
                data_dic["FechaNacimiento"],
                data_dic["telefono"],
                data_dic["pais"],
                data_dic["idTipo"],
                data_dic["Foto"],
            )
            return userObj
        else:
            return None


class RegisterLogic(Logic):
    def __init__(self):
        super().__init__()

    def insertNewUser(
        self, user, nombre_completo, correo, password, Fecha, telefono, pais, Foto
    ):
        database = self.get_databaseXObj()
        sql = (
            "insert into proyectozeus.usuarios (`idUsuario`, `Usuario`, `nombre_completo`, `correo`, "
            + "`contraseña`, `FechaNacimiento`, `telefono`, `pais`, `idTipo`, `Foto`) "
            + f"values (0, '{user}', '{nombre_completo}', '{correo}', '{password}', '{Fecha}', '{telefono}', '{pais}', 2, '{Foto}');"
        )
        rows = database.executeNonQueryRows(sql)
        return rows


class RegisterViajeLogic(Logic):
    def __init__(self):
        super().__init__()

    def insertNewViaje(
        self,
        idViajero,
        fechaInicio,
        fechaRegreso,
        paisDestino,
        direccionEstadia,
        cobroLibra,
        telefono,
        imagenReferencia,
    ):
        database = self.get_databaseXObj()
        sql = (
            "INSERT INTO proyectozeus.viajes (`idviaje`, `idViajero`, `fecha de inicio`, `fecha de regreso`, `Activo`, `Pais Destino`, `direccion de estadia`, `cobro por libra`, "
            + "`telefono`,`imagen referencia`) "
            + f"values ('0', '{idViajero}','{fechaInicio}', '{fechaRegreso}', 'Sí', '{paisDestino}', '{direccionEstadia}', '{cobroLibra}', '{telefono}', '{imagenReferencia}');"
        )
        rows = database.executeNonQueryRows(sql)
        return rows


class RequestLogic(Logic):
    def __init__(self):
        super().__init__()

    def NewRequest(
        self,
        user,
        nombre_completo,
        correo,
        password,
        Fecha,
        telefono,
        Motivos,
        Frecuencia,
        pais,
        Foto,
    ):
        database = self.get_databaseXObj()
        sql = (
            "insert into proyectozeus.solicitudes (`idSolicitud`, `Usuario`, `nombre_completo`, `correo`, "
            + "`contraseña`, `FechaNacimiento`, `telefono`, `MotivosViaje`,`FrecuenciaViaje`,`EstadoSolicitud`,`pais`, `Foto`) "
            + f"values (0, '{user}', '{nombre_completo}', '{correo}', '{password}', '{Fecha}', '{telefono}', '{Motivos}', '{Frecuencia}', 'Pendiente','{pais}', '{Foto}');"
        )
        rows = database.executeNonQueryRows(sql)
        return rows


class EstadoLogic(Logic):
    def __init__(self):
        super().__init__()

    def UpdateRequest(self, id, estado):
        database = self.get_databaseXObj()
        sql = f"UPDATE `proyectozeus`.`solicitudes` SET `EstadoSolicitud` = '{estado}' WHERE (`idSolicitud` = '{id}');"
        rows = database.executeNonQueryRows(sql)
        return rows


class GetRequests(Logic):
    def __init__(self):
        super().__init__()

    def GetRequests(self):
        database = self.get_databaseXObj()
        sql = (
            f"SELECT * FROM proyectozeus.solicitudes where EstadoSolicitud='Pendiente';"
        )
        data = database.executeQuery(sql)
        return data


class DeleteUser(Logic):
    def __init__(self):
        super().__init__()

    def DeleteUser(self, id):
        database = self.get_databaseXObj()
        sql = f"DELETE FROM proyectozeus.usuarios WHERE (`idUsuario` = '{id}');"
        rows = database.executeNonQueryRows(sql)
        return rows


class UserShowLogic(Logic):
    def __init__(self):
        super().__init__()

    def ShowUsers(self):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.usuarios;"
        data = database.executeQuery(sql)
        return data


class ViajesLogic(Logic):
    def __init__(self):
        super().__init__()

    def GetViajes(self, fechainicio, fechafinal, paisOrigen):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.viajes_view where `Inicio de Viaje` >= '{fechainicio}' and `Regreso de Viaje` <= '{fechafinal}' and `Activo` = 'Sí' and `PaisOrigen` = '{paisOrigen}';"
        data = database.executeQuery(sql)
        return data


class ConfirmarLogic(Logic):
    def ViajeByid(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.viajes_view where idViaje = {id};"
        data = database.executeQuery(sql)
        return data


class PedidoLogic(Logic):
    def __init__(self):
        super().__init__()

    def insertNewPedido(
        self,
        idUsuario,
        idViajero,
        idViaje,
        NombreArticulo,
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
    ):
        database = self.get_databaseXObj()
        sql = (
            "INSERT INTO `proyectozeus`.`pedidos` (`idPedido`, `idUsuario`, `idViajero`, `idViaje`, `NombreArticulo`, `EstadoPedido`, "
            + "`Precio`, `Peso`, `Categoria`, `Cantidad`, `Especificaciones`, `URL`, `Pais`, `FechaPedido`,`FechaEntrega`, `Total`, `Calificado`) "
            + f"VALUES ('0', '{idUsuario}', '{idViajero}', '{idViaje}', '{NombreArticulo}', 'Pendiente', '{Precio}', '{Peso}', '{Categoria}',"
            + f"'{Cantidad}', '{Especificaciones}', '{URL}', '{Pais}', '{FechaPedido}','{Fecha}', '{Total}', '0');"
        )
        rows = database.executeNonQueryRows(sql)
        return rows


class idViajeroLogic(Logic):
    def __init__(self):
        super().__init__()

    def getidViajero(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT idViajero FROM proyectozeus.viajeros where idUsuario='{id}';"
        data = database.executeQuery(sql)
        return data


class UserShowPedidos(Logic):
    def __init__(self):
        super().__init__()

    def ShowPedidos(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.pedidos_view where idUsuario='{id}';"
        data = database.executeQuery(sql)
        return data


class ViajerosShowAdminLogic(Logic):
    def __init__(self):
        super().__init__()

    def ShowViajerosAdmin(self):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.viajeros;"
        data = database.executeQuery(sql)
        return data


class PedidosShowAdminLogic(Logic):
    def __init__(self):
        super().__init__()

    def ShowPedidosAdmin(self):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.pedidos;"
        data = database.executeQuery(sql)
        return data


class ShowViajesViajero(Logic):
    def __init__(self):
        super().__init__()

    def ShowViajesViajero(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.viajes where idViajero='{id}';"
        data = database.executeQuery(sql)
        return data


class calificarviajero(Logic):
    def __init__(self):
        super().__init__()

    def calificarviajero(
        self, idUsuarioCalificador, idUsuarioCalificado, idPedido, Nota, Comentarios
    ):
        database = self.get_databaseXObj()
        sql = (
            "INSERT INTO `proyectozeus`.`calificaciones` (`idcalificaciones`, `idUsuarioCalificador`, `idUsuarioCalificado`, `idPedido`, `Nota`, `Comentarios`) "
            + f"VALUES (0,'{idUsuarioCalificador}','{idUsuarioCalificado}', '{idPedido}', '{Nota}', '{Comentarios}');"
        )

        rows = database.executeNonQueryRows(sql)
        return rows


class ViajeroPedidos(Logic):
    def __init__(self):
        super().__init__()

    def ShowPedidosViajero(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.pedidos_view where idViajero='{id}';"
        data = database.executeQuery(sql)
        return data


class SolicitudPedidos(Logic):
    def __init__(self):
        super().__init__()

    def SolicitudPedidos(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.pedidos_view where idViajero='{id}' and Estado = 'Pendiente';"
        data = database.executeQuery(sql)
        return data


class UpdatePedidoLogic(Logic):
    def __init__(self):
        super().__init__()

    def UpdatePedido(self, id, estado):
        database = self.get_databaseXObj()
        sql = f"UPDATE proyectozeus.pedidos SET EstadoPedido = '{estado}' WHERE (`idPedido` = '{id}');"
        rows = database.executeNonQueryRows(sql)
        return rows


class ActualizarLogic(Logic):
    def PedidoByid(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.pedidos_view where idPedido = {id};"
        data = database.executeQuery(sql)
        return data


class idUserLogic(Logic):
    def __init__(self):
        super().__init__()

    def getidViajeroUsuario(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT idUsuario FROM proyectozeus.viajeros where idViajero='{id}';"
        data = database.executeQuery(sql)
        return data


class DisponibilidadViajero(Logic):
    def __init__(self):
        super().__init__()

    def DisponibilidadViajero(self, id, estado):
        database = self.get_databaseXObj()
        sql = f"UPDATE proyectozeus.viajes SET Activo = '{estado}' WHERE (`idviaje` = '{id}');"
        rows = database.executeNonQueryRows(sql)
        return rows


class PerfilUsuario(Logic):
    def __init__(self):
        super().__init__()

    def getPerfilUsuario(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.usuarios where idUsuario='{id}';"
        data = database.executeQuery(sql)
        return data


class PerfilViajero(Logic):
    def __init__(self):
        super().__init__()

    def getPerfilViajero(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.viajeros where idViajero='{id}';"
        data = database.executeQuery(sql)
        return data


class NotasViajero(Logic):
    def __init__(self):
        super().__init__()

    def getNotasViajero(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.calificaciones_view where idUserCalificado='{id}';"
        data = database.executeQuery(sql)
        return data


class ViajesDispViajero(Logic):
    def __init__(self):
        super().__init__()

    def ShowViajesDisp(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.viajes where idViajero='{id}' and Activo = 'Sí';"
        data = database.executeQuery(sql)
        return data


class UserShowFacturas(Logic):
    def __init__(self):
        super().__init__()

    def ShowFacturas(self, id):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.pedidos_view where Estado != 'Pendiente' and Estado != 'Rechazado' and idUsuario = '{id}';"
        data = database.executeQuery(sql)
        return data


class AdminShowFacturas(Logic):
    def __init__(self):
        super().__init__()

    def ShowAllFacturas(self):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.pedidos_view where Estado != 'Pendiente' and Estado != 'Rechazado';"
        data = database.executeQuery(sql)
        return data


class AdminShowCalificaciones(Logic):
    def __init__(self):
        super().__init__()

    def ShowAllNotas(self):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.calificaciones_view;"
        data = database.executeQuery(sql)
        return data


class UpdatePerfil(Logic):
    def __init__(self):
        super().__init__()

    def UpdatePerfil(self, id, Usuario, correo, password, telefono, pais, Foto):
        database = self.get_databaseXObj()
        sql = f"UPDATE proyectozeus.usuarios SET Usuario = '{Usuario}', correo = '{correo}', contraseña = '{password}', telefono = '{telefono}', pais = '{pais}', Foto = '{Foto}' WHERE (`idUsuario` = '{id}');"
        rows = database.executeNonQueryRows(sql)
        return rows


class UpdatePerfilViajero(Logic):
    def __init__(self):
        super().__init__()

    def UpdatePerfilViajero(self, id, Usuario, correo, password, telefono, pais, Foto):
        database = self.get_databaseXObj()
        sql = f"UPDATE proyectozeus.viajeros SET Usuario = '{Usuario}', correo = '{correo}', contraseña = '{password}', telefono = '{telefono}', pais = '{pais}', Foto = '{Foto}' WHERE (`idUsuario` = '{id}');"
        rows = database.executeNonQueryRows(sql)
        return rows


class ViajesAdminLogic(Logic):
    def __init__(self):
        super().__init__()

    def GetViajesAdmin(self):
        database = self.get_databaseXObj()
        sql = f"SELECT * FROM proyectozeus.viajes_view;"
        data = database.executeQuery(sql)
        return data
