import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../utils/api_backend.dart';

class PaginaHome extends StatefulWidget {
  const PaginaHome({Key? key}) : super(key: key);

  @override
  _PaginaHomeState createState() => _PaginaHomeState();
}

class _PaginaHomeState extends State<PaginaHome> {
  List<Producto> productos = [];

  @override
  void initState() {
    super.initState();
    _cargarProductos();
  }

  Future<void> _cargarProductos() async {
    final response = await http.get(Uri.parse('http://$apiBackend/productos'));

    if (response.statusCode == 200) {
      // Si la solicitud fue exitosa, parsea el JSON
      final List<dynamic> data = json.decode(response.body);
      setState(() {
        productos = data.map((item) => Producto.fromJson(item)).toList();
      });
    } else {
      // Si la solicitud no fue exitosa, muestra un mensaje de error
      throw Exception('Error al cargar productos');
    }
  }

  @override
 Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          Container(
            child: _swiper(),
          ),
          Container(
            height: 400,
            child: ListView.builder(
              itemCount: productos.length,
              itemBuilder: (context, index) {
                return ListTile(
                  title: Text(productos[index].nombre),
                  subtitle: Text('\$${productos[index].precioVenta.toString()}'),
                  leading: Container(
                    width: 50, // Ancho fijo deseado para la imagen
                    child: Image.network(
                      imagenes[index], // Utiliza la lista de imágenes directamente
                      fit: BoxFit.fill,
                    ),
                  ),
                  onTap: () {
                    _mostrarDetalles(productos[index]);
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _swiper() {
    return Container(
      width: double.infinity,
      height: 300,
      child: Swiper(
        viewportFraction: 0.8,
        scale: 0.9,
        itemBuilder: (BuildContext context, int index) {
          return Image.network(
            imagenes[index],
            fit: BoxFit.fill,
          );
        },
        itemCount: imagenes.length,
        pagination: SwiperPagination(),
        control: SwiperControl(),
      ),
    );
  }

  void _mostrarDetalles(Producto producto) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(producto.nombre),
          content: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text('Descripción: ${producto.descripcion}'),
              Text('Precio: \$${producto.precioVenta.toString()}'),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cerrar'),
            ),
          ],
        );
      },
    );
  }
}

class Producto {
  final int id;
  final String nombre;
  final String descripcion;
  final double precioVenta;

  Producto({
    required this.id,
    required this.nombre,
    required this.descripcion,
    required this.precioVenta,
  });

  factory Producto.fromJson(Map<String, dynamic> json) {
  return Producto(
    id: json['id'],
    nombre: json['nombre'],
    descripcion: json['descripcion'],
    precioVenta: double.parse(json['precio_venta'].toString()),
  );
}
}


List<String> imagenes = [
  "https://storage.googleapis.com/catalog-pictures-carrefour-es/catalog/pictures/hd_510x_/8807622351105_1.jpg",
  "https://www.autofacil.es/wp-content/uploads/2022/01/03-dunlop.jpg",
  "https://llanteramoya.com/wp-content/uploads/2018/06/BFGoodrich-Mud-Terrain-300x254.jpg",
  "https://www.autonocion.com/wp-content/uploads/2018/06/Aceite-motor-2.jpg",
  "https://stpimagecdn.imgix.net/wp-content/uploads/sites/3/product-images/19505_01.png?auto=format%2Ccompress&fit=crop&w=600&max-h=600",
  "https://www.pennzoil.com/es_us/products/other-oils-fluids-fuel/automatic-transmission-fluids/_jcr_content/pagePromo/image.img.960.jpeg/1465341336281/AutomaticTransmissionFluid.jpeg",
  "https://stpimagecdn.imgix.net/wp-content/uploads/sites/3/product-images/E302905300_01.png?auto=format%2Ccompress&fit=crop&w=600&max-h=600",
  "https://vistony.com.bo/wp-content/uploads/2021/03/LIQUIDO-PARA-RADIADOR-VERDE-_-1-GAL.png",
  "https://i5.walmartimages.com.mx/gr/images/product-images/img_large/00750046312785L.jpg?odnHeight=612&odnWidth=612&odnBg=FFFFFF",
  "https://stpimagecdn.imgix.net/wp-content/uploads/sites/3/product-images/E302892600_01.png",
];
