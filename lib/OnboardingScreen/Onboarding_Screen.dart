import 'package:flutter/material.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Con la nueva\napp de ByKon,\nponemos al área\nde RH en la\npalma de tu\nmano',
      'buttonText': 'Siguiente',
    },
    {
      'title': 'Consulta y\ndescarga tus\ncomprobantes de\nnómina o\naguinaldo',
      'buttonText': 'Siguiente',
    },
    {
      'title': 'Registra tus\nactividades en la\nbitácora o solicita\ntus vacaciones\ndesde tu celular',
      'buttonText': 'Empezar',
    },
  ];

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  void _nextPage() {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      print('Navegar a la siguiente pantalla');
    }
  }

  void _skipOnboarding() {
    print('Omitir onboarding');
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Imagen de fondo con opacidad
          Positioned.fill(
            child: Stack(
              children: [
                Image.asset(
                  'assets/image.png', // Ruta de tu imagen
                  fit: BoxFit.cover, // Asegura que ocupe toda la pantalla
                  width: double.infinity,
                  height: double.infinity,
                ),
                Container(
                  color: Colors.black.withOpacity(0.4), // Opacidad del 60%
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Contenido del onboarding
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    itemCount: _onboardingData.length,
                    onPageChanged: (index) {
                      setState(() {
                        _currentPage = index;
                      });
                    },
                    itemBuilder: (context, index) {
                      return Padding(
                        padding: const EdgeInsets.all(32.0),
                        child: Center(
                          child: Text(
                            _onboardingData[index]['title']!,
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              fontSize: 28,
                              color: Colors.white,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                // Botones inferiores
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage < _onboardingData.length - 1)
                        OutlinedButton(
                          onPressed: _skipOnboarding,
                          style: OutlinedButton.styleFrom(
                            foregroundColor: Colors.white,
                            side: BorderSide(color: Colors.white, width: 1),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(25),
                            ),
                            padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                          ),
                          child: Text('Omitir', style: TextStyle(fontSize: 16)),
                        ),
                      Spacer(),
                      ElevatedButton(
                        onPressed: _nextPage,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          foregroundColor: Colors.black,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(25),
                          ),
                          padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                        ),
                        child: Text(
                          _onboardingData[_currentPage]['buttonText']!,
                          style: TextStyle(fontSize: 16),
                        ),
                      ),
                      if (_currentPage < _onboardingData.length - 1) Spacer(),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

void main() {
  runApp(MaterialApp(
    home: OnboardingScreen(),
  ));
}