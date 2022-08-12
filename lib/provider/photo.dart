class Photo {
 final id;
 final id_facility;
 final path_photo;

 Photo({ this.id= ' ', this.id_facility=0 ,required this.path_photo});

 factory Photo.fromJson(Map<String, dynamic> json) => Photo(
 path_photo:json['path_photo'].toString() ,
  id:json['id'].toString() ,
  id_facility:json['id_facility'].toString()
 );




}