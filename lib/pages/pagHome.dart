import 'package:flutter/material.dart';
import 'package:card_swiper/card_swiper.dart';

class PaginaHome extends StatelessWidget {
  const PaginaHome({super.key});

  Widget build(BuildContext context) {
    return Column(
      children: [
        Container(
          child: _swiper(),
        ),
        Container(
          height: 400,
          child: ListView(
            children: [
              Container(
                child: Image.network(
                    "https://hvhindustrial.com/images/frontend_images/blogs/1592499808Electric-Motor.jpg"),
              ),
              Column(
                children: [
                  Text("MOTOR ELECTRICO"),
                  TextButton(onPressed: () {}, child: Text("Comprar"))
                ],
              ),
              //2
              Container(
                child: Image.network(
                    "https://cdn-images.motor.es/image/m/720w.webp/fotos-diccionario/2019/11/bujia-tipos-averias-mantenimiento_1573747483.jpg"),
              ),
              Column(
                children: [
                  Text("Bujia"),
                  TextButton(onPressed: () {}, child: Text("Comprar"))
                ],
              ),
              //3
              Container(
                child: Image.network(
                    "https://stpimagecdn.imgix.net/wp-content/uploads/sites/3/product-images/17078B_01.png?auto=format%2Ccompress&fit=crop&w=600&max-h=600"),
              ),
              Column(
                children: [
                  Text("Liquido para dirección hidraulica"),
                  TextButton(onPressed: () {}, child: Text("Comprar"))
                ],
              )
            ],
          ),
        ),
      ],
    );
  }
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

List<String> imagenes = [
  "https://www.agsa.com/cdn/shop/products/GATO2TN.jpg?v=1646768569",
  "https://www.prindusat.com/wp-content/uploads/2019/06/5261P.jpg",
  "https://multimedia.3m.com/mws/media/1026186J/sandpaper-211q-picture.jpg?width=506",
  "https://www.victormorales.cl/149-superlarge_default/juego-de-destornilladores-bahco-b219006.jpg",
];
