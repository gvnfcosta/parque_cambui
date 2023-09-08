List<String> reunioes = ['Reunião Pública', 'Vida e Ministério', 'Eventos'];
List<String> eventos = ['Celebração', 'Assembléias', 'Congresso'];
List<String> ministerio = [
  'Serviço de Campo',
  'Grupos de Campo',
  'Testemunho Público'
];

class Constants {
  static const baseUrl = 'https://pqcambui-41a18-default-rtdb.firebaseio.com/';

  static const webApiKey = 'AIzaSyBiVU3DDTbAWHJ7kdjIbB-sUr7-M7iiCN0';

  /// Checks if string is email.
  static bool isEmail(String s) => hasMatch(s,
      r'^(([^<>()[\]\\.,;:\s@\"]+(\.[^<>()[\]\\.,;:\s@\"]+)*)|(\".+\"))@((\[[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\.[0-9]{1,3}\])|(([a-zA-Z\-0-9]+\.)+[a-zA-Z]{2,}))$');

  static bool hasMatch(String? value, String pattern) {
    return (value == null) ? false : RegExp(pattern).hasMatch(value);
  }
}

const oradorImage =
    "https://firebasestorage.googleapis.com/v0/b/pqcambui-41a18.appspot.com/o/images%2FOrador_Ale.jpg?alt=media&token=80c7bcd1-c8e7-4eed-b365-ad3986c75949";
// "https://firebasestorage.googleapis.com/v0/b/pqcambui-41a18.appspot.com/o/images%2FRFSCartoon.jpg?alt=media&token=512a88ed-02c0-454f-9dc0-d9b97ff4db74";

const testemunhoImage =
    "https://firebasestorage.googleapis.com/v0/b/pqcambui-41a18.appspot.com/o/images%2FRvmc_Ale.jpg?alt=media&token=eb8fc1fc-20fc-4f28-935e-18291c904793";
// "https://firebasestorage.googleapis.com/v0/b/pqcambui-41a18.appspot.com/o/images%2FRvmcCartoon.jpg?alt=media&token=5f017467-e578-47d4-a532-3452f1545009";

const publisherCartImage =
    'https://firebasestorage.googleapis.com/v0/b/pqcambui-41a18.appspot.com/o/images%2FJwCart_1.jpg?alt=media&token=da3bcac0-1215-4b8f-9ff2-becf9c7d52d0';

const publisherCartImage_2 =
    'https://firebasestorage.googleapis.com/v0/b/pqcambui-41a18.appspot.com/o/images%2FJwCart_1.jpg?alt=media&token=da3bcac0-1215-4b8f-9ff2-becf9c7d52d0';

const celebUrl =
    'https://assetsnffrgf-a.akamaihd.net/assets/a/mi23/T/wpub/mi23_T_lg.jpg';

const assUrl =
    'https://assetsnffrgf-a.akamaihd.net/assets/a/ca-brpgm23/T/wpub/CA-brpgm23_T_lg.jpg';

const congUrl =
    'https://assetsnffrgf-a.akamaihd.net/assets/a/co-pgm22/T/wpub/CO-pgm22_T_lg.jpg';
