class UserObj:
    def __init__(
        self,
        id,
        user,
        nombre_completo,
        correo,
        password,
        Fecha,
        telefono,
        pais,
        idTipo,
        Foto,
    ):
        self.id = id
        self.user = user
        self.name = nombre_completo
        self.email = correo
        self.date = Fecha
        self.phone = telefono
        self.country = pais
        self.password = password
        self.Tipo = idTipo
        self.Foto = Foto
