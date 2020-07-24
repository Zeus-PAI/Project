from Logic import Logic
from userobj import UserObj
from Solicitudobj import SolicitudObj


class UserLogic(Logic):
    def __init__(self):
        super().__init__()
        self.keys = ["idUsuario", "Usuario", "nombre_completo", "correo", "contraseña", "Fecha de Nacimiento", "telefono", "pais de residencia", "idTipo"]

    def getUserData(self, user):
        database = self.get_databaseXObj()
        sql = f"select * from proyectozeus.usuarios where Usuario='{user}';"
        data = database.executeQuery(sql)
        data = self.tupleToDictionaryList(data, self.keys)
        if len(data) > 0:
            data_dic = data[0]
            userObj = UserObj(
                data_dic["idUsuario"], data_dic["Usuario"], data_dic["nombre_completo"], data_dic["correo"],
                data_dic["contraseña"], data_dic["Fecha de Nacimiento"], data_dic["telefono"], data_dic["pais de residencia"], data_dic["idTipo"]
            )
            return userObj
        else:
            return None


class RegisterLogic(Logic):
    def __init__(self):
        super().__init__()

    def insertNewUser(self, user, nombre_completo, correo, password, Fecha, telefono, pais):
        database = self.get_databaseXObj()
        sql = (
            "insert into proyectozeus.usuarios (`idUsuario`, `Usuario`, `nombre_completo`, `correo`, "
            + "`contraseña`, `FechaNacimiento`, `telefono`, `pais`, `idTipo`) "
            + f"values (0, '{user}', '{nombre_completo}', '{correo}', '{password}', '{Fecha}', '{telefono}', '{pais}', 2);"
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
