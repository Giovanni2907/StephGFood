class CarouselItemData {
  final String imagePath;
  final String title;
  final String description;

  CarouselItemData({
    required this.imagePath,
    required this.title,
    required this.description,
  });
}

final List<CarouselItemData> carouselItems = [
  CarouselItemData(
    imagePath: 'assets/images/plat1.png',
    title: 'Offre spéciale du mois',
    description: 'Découvrez cette spécialité du chef.',
  ),
  CarouselItemData(
    imagePath: 'assets/images/plat1.png',
    title: 'Offre Spéciale -50%',
    description: 'Profitez des réductions exclusives dès aujourd\'hui.',
  ),
  CarouselItemData(
    imagePath: 'assets/images/plat1.png',
    title: 'Black friday',
    description: 'À partir de 50€ livraison inclus.',
  ),
];