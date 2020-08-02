function calcularCosto() {
    var precio = parseFloat(document.getElementById("precio").value);
    var cantidad = parseFloat(document.getElementById("cantidad").value);
    var cobro = parseFloat(document.getElementById("costo").value);
    var peso = parseFloat(document.getElementById("peso").value);
    result = (precio * cantidad) + (cobro * peso * cantidad);
    console.log("result-->" + result)
    document.getElementById("resultado").innerHTML = "$ " + result;
    document.getElementById("total").value = result;
}