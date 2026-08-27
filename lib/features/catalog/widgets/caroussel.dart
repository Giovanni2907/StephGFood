import 'dart:async'; 
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:steph_g_food/core/constants/app_colors.dart';
import 'package:steph_g_food/features/catalog/models/list_card.dart';


class EcommerceCarouselCard extends StatefulWidget {
  const EcommerceCarouselCard({Key? key}) : super(key: key);

  @override
  State<EcommerceCarouselCard> createState() => _EcommerceCarouselCardState();
}

class _EcommerceCarouselCardState extends State<EcommerceCarouselCard> {
  final PageController _pageController = PageController();
  int _currentPage = 0;
  Timer? _timer; // 2. Variable pour stocker le Timer

  @override
  void initState() {
    super.initState();
    _startAutoPlay(); // 3. Lancement de l'auto-play à l'initialisation
  }

  // Fonction qui gère le défilement automatique
  void _startAutoPlay() {
    _timer = Timer.periodic(const Duration(seconds: 5), (timer) {
      if (_pageController.hasClients) {
        int nextPage = _currentPage + 1;

        // Si on atteint la fin, on repasse à la première image
        if (nextPage >= carouselItems.length) {
          nextPage = 0;
        }

        _pageController.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 600), // Durée de la transition
          curve: Curves.easeInOut,                      // Animation fluide
        );
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // 4. IMPORTANT : Toujours annuler le timer pour éviter les fuites de mémoire
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 200,
      child: ClipRRect(
        borderRadius: BorderRadius.circular(20),
        child: Stack(
          children: [
            PageView.builder(
              controller: _pageController,
              itemCount: carouselItems.length,
              onPageChanged: (int index) {
                setState(() {
                  _currentPage = index;
                });
              },
              itemBuilder: (context, index) {
                final item = carouselItems[index];

                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Image.asset(
                      item.imagePath,
                      fit: BoxFit.cover,
                    ),
                    Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            Colors.transparent,
                            Colors.black.withOpacity(0.7),
                          ],
                        ),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.end,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            item.title,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            item.description,
                            style: const TextStyle(
                              color: Colors.white70,
                              fontSize: 14,
                            ),
                          ),
                          const SizedBox(height: 70),
                        ],
                      ),
                    ),
                  ],
                );
              },
            ),

            // Indicateurs
            Positioned(
              top: 16,
              right: 16,
              child: Row(
                children: List.generate(
                  carouselItems.length,
                  (index) => AnimatedContainer(
                    duration: const Duration(milliseconds: 300),
                    margin: const EdgeInsets.symmetric(horizontal: 4),
                    height: 8,
                    width: _currentPage == index ? 24 : 8,
                    decoration: BoxDecoration(
                      color: _currentPage == index
                          ? Colors.white
                          : Colors.white.withOpacity(0.4),
                      borderRadius: BorderRadius.circular(4),
                    ),
                  ),
                ),
              ),
            ),

            // Bouton fixe
            Positioned(
              bottom: 16,
              left: 40,
              right: 40,
              child: SizedBox(
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                  ),
                  onPressed: () {
                    context.pushNamed('cart');
                  },
                  child: const Text(
                    "Passer commande",
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}