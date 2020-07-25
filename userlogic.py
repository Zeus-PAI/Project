from Logic import Logic
from userobj import UserObj
from Solicitudobj import SolicitudObj


class UserLogic(Logic):
    def __init__(self):
        super().__init__()
        self.keys = ["idUsuario", "Usuario", "nombre_completo", "correo", "contraseña", "FechaNacimiento", "telefono", "pais", "idTipo", "Foto"]

    def getUserData(self, user):
        database = self.get_databaseXObj()
        sql = f"select * from proyectozeus.usuarios where Usuario='{user}';"
        data = database.executeQuery(sql)
        data = self.tupleToDictionaryList(data, self.keys)
        if len(data) > 0:
            data_dic = data[0]
            userObj = UserObj(
                data_dic["idUsuario"], data_dic["Usuario"], data_dic["nombre_completo"], data_dic["correo"],
                data_dic["contraseña"], data_dic["FechaNacimiento"], data_dic["telefono"], data_dic["pais"], data_dic["idTipo"],
                data_dic["Foto"]
            )
            return userObj
        else:
            return None


class RegisterLogic(Logic):
    def __init__(self):
        super().__init__()

    def insertNewUser(self, user, nombre_completo, correo, password, Fecha, telefono, pais, Foto):
        database = self.get_databaseXObj()
        sql = (
            "insert into proyectozeus.usuarios (`idUsuario`, `Usuario`, `nombre_completo`, `correo`, "
            + "`contraseña`, `FechaNacimiento`, `telefono`, `pais`, `idTipo`, `Foto`) "
            + f"values (0, '{user}', '{nombre_completo}', '{correo}', '{password}', '{Fecha}', '{telefono}', '{pais}', 2, '{Foto}');"
        )
        rows = database.executeNonQueryRows(sql)
        return rows


class RequestLogic(Logic):
    def __init__(self):
        super().__init__()

    def NewRequest(self, user, nombre_completo, correo, password, Fecha, telefono, Motivos, Frecuencia, pais, Foto):
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
        sql = f"SELECT * FROM proyectozeus.solicitudes where EstadoSolicitud='Pendiente';"
        data = database.executeQuery(sql)
        return data
