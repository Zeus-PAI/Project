class SolicitudObj:
    def __init__(self, id, user, nombre_completo, correo, password, Fecha, telefono, Motivos, Frecuencia, Foto, pais):
        self.id = id
        self.user = user
        self.name = nombre_completo
        self.email = correo
        self.date = Fecha
        self.phone = telefono
        self.country = pais
        self.password = password
        self.motivos = Motivos
        self.frecuencia = Frecuencia
        self.foto = Foto

    