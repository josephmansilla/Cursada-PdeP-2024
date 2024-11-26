%primeraMarca(Marca)
primeraMarca(laSerenisima).
primeraMarca(gallo).
primeraMarca(vienisima).

%precioUnitario(Producto,Precio)
%donde Producto puede ser arroz(Marca), lacteo(Marca,TipoDeLacteo), salchichas(Marca,Cantidad)
precioUnitario(arroz(gallo),25.10).
precioUnitario(lacteo(laSerenisima,leche), 6.00).
precioUnitario(lacteo(laSerenisima,crema), 4.00).
precioUnitario(lacteo(gandara,queso(gouda)), 13.00).
precioUnitario(lacteo(vacalin,queso(mozzarella)), 12.50).
precioUnitario(salchichas(vienisima,12), 9.80).
precioUnitario(salchichas(vienisima, 6), 5.80).
precioUnitario(salchichas(granjaDelSol, 8), 5.10).

%descuento(Producto, Descuento)
descuento(lacteo(laSerenisima,leche), 0.20).
descuento(lacteo(laSerenisima,crema), 0.70).
descuento(lacteo(gandara,queso(gouda)), 0.70).
descuento(lacteo(vacalin,queso(mozzarella)), 0.05).
%% PUNTO 1
descuento(arroz(_), 1.50).
descuento(salchichas(Marca, _), 0.50):- Marca \= vienisima.
descuento(lacteo(_, leche),2).
descuento(lacteo(Marca, queso(_)),2):- primeraMarca(Marca).
descuento(UnProducto, 0.05):- 
    forall( (precioUnitario(UnProducto,Precio1), precioUnitario(OtroProducto, Precio2)) , (Precio1 > Precio2, UnProducto \= OtroProducto)).

%compro(Cliente,Producto,Cantidad)
compro(juan, lacteo(laSerenisima,crema), 2).


%% PUNTO 2
compradorCompulsivo(nombreComprador):-
    compro(nombreComprador,_,_),
    forall((compro(nombreComprador, NombreProducto, _), precioUnitario(NombreProducto,_)), (esPrimeraMarca(NombreProducto), descuento(NombreProducto, _))).

esPrimeraMarca(arroz(marca)):- primeraMarca(marca).
esPrimeraMarca(lacteo(marca, _)):- primeraMarca(marca).
esPrimeraMarca(salchichas((marca, _), _)):- primeraMarca(marca).

%% PUNTO 3
cliente(NombreCliente):- compro(NombreCliente, _, _).

totalAPagar(NombreCliente, TotalCompra):-
    cliente(NombreCliente),
    findall(Compra, (compro(NombreCliente, Producto, Cantidad), costo(Producto, Cantidad, Compra)) ,Compras),
    sumlist(Compras, TotalCompra).

costo(Producto, Cantidad, Total):-
    precioUnitario(Producto, PrecioBase),
    descuentos(Producto, PrecioBase, Precio),
    Total is Precio * Cantidad.

descuentos(Producto, PrecioBase, Precio):-
    descuento(Producto, Descuento),
    Precio is PrecioBase - Descuento.

%% PUNTO 4
marca(NombreMarca):- precioUnitario(arroz(NombreMarca), _).
marca(NombreMarca):- precioUnitario(lacteo(NombreMarca, _), _).
marca(NombreMarca):- precioUnitario(salchichas(NombreMarca, _), _).

clienteFiel(NombreCliente, NombreMarca):-
    cliente(NombreCliente),
    marca(NombreMarca),
    forall( (compro(NombreCliente, Producto, _), marcaDe(Producto, NombreMarca), 
            compro(NombreCliente, OtroProducto, _), marcaDe(OtroProducto, OtroNombreMarca)), 
            (NombreMarca == OtroNombreMarca, Producto \= OtroProducto)).

marcaDe(arroz(NombreMarca), NombreMarca).
marcaDe(lacteo(NombreMarca,_), NombreMarca).
marcaDe(salchichas(NombreMarca,_), NombreMarca).

%% PUNTO 5

dueno(laSerenisima, gandara).
dueno(gandara, vacalin).

provee(laSerenisima, lacteos).
provee(vacalin, dulceLeche).

provee(Empresa, Productos):- 
    dueno(Empresa, OtraEmpresa),
    provee(OtraEmpresa, Productos).