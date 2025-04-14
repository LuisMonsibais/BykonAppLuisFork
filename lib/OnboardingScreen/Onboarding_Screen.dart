import 'package:flutter/material.dart';
import '../Login/login_screen.dart';
import 'package:shared_preferences/shared_preferences.dart';

class OnboardingScreen extends StatefulWidget {
  const OnboardingScreen({super.key});

  @override
  _OnboardingScreenState createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen> {
  int _currentPage = 0;
  final PageController _pageController = PageController(initialPage: 0);

  final List<Map<String, String>> _onboardingData = [
    {
      'title': 'Con la nueva\nByKon App,\nponemos al área\nde RH en la\npalma de tu\nmano',
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

  void _skipOnboarding() async {
    // Guarda el estado en SharedPreferences
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('hasSeenOnboarding', true);

    // Navega directamente a la pantalla de Login
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(builder: (context) => LoginScreen()),
    );
  }

  void _nextPage() async {
    if (_currentPage < _onboardingData.length - 1) {
      _pageController.nextPage(
        duration: Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    } else {
      // Guarda el estado en SharedPreferences
      final prefs = await SharedPreferences.getInstance();
      await prefs.setBool('hasSeenOnboarding', true);

      // Navega a la pantalla de Login
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => LoginScreen()),
      );
    }
  }

  @override
  void dispose() {
    _pageController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          Positioned.fill(
            child: Stack(
              children: [
                Transform.scale(
                  scale: 1.8,
                  child: Image.asset(
                    'assets/image.png',
                    fit: BoxFit.cover,
                    width: double.infinity,
                    height: double.infinity,
                  ),
                ),
                Container(
                  color: Colors.black.withOpacity(0.7),
                ),
              ],
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Barra indicadora
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: List.generate(
                    _onboardingData.length,
                    (index) => AnimatedContainer(
                      duration: Duration(milliseconds: 300),
                      margin: EdgeInsets.symmetric(horizontal: 4),
                      width: 110, // Longitud de las barras indicadoras
                      height: 8, // Altura fija para las barras
                      decoration: BoxDecoration(
                        color: _currentPage == index
                            ? Colors.red
                            : Colors.white.withOpacity(0.5), // Rojo para la barra activa
                        borderRadius: BorderRadius.circular(4), // Bordes redondeados
                      ),
                    ),
                  ),
                ),
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
                        padding: const EdgeInsets.only(left: 16.0, right: 32.0), // Ajusta el padding para pegar el texto a la izquierda
                        child: Align(
                          alignment: Alignment.centerLeft, // Alinea el texto a la izquierda
                          child: Text(
                            _onboardingData[index]['title']!,
                            textAlign: TextAlign.start, // Alinea el texto a la izquierda
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
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    mainAxisAlignment: _currentPage == _onboardingData.length - 1
                        ? MainAxisAlignment.center
                        : MainAxisAlignment.spaceBetween,
                    children: [
                      if (_currentPage < _onboardingData.length - 1)
                        SizedBox(
                          width: 160,
                          child: OutlinedButton(
                            onPressed: _skipOnboarding,
                            style: OutlinedButton.styleFrom(
                              foregroundColor: Colors.white,
                              side: BorderSide(color: Colors.white, width: 1),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            child: Center(
                              child: Text('Omitir', style: TextStyle(fontSize: 16)),
                            ),
                          ),
                        ),
                      if (_currentPage < _onboardingData.length - 1)
                        SizedBox(width: 12),
                      if (_currentPage < _onboardingData.length - 1)
                        SizedBox(
                          width: 160,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                            ),
                            child: Center(
                              child: Text(
                                _onboardingData[_currentPage]['buttonText']!,
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
                      if (_currentPage == _onboardingData.length - 1)
                        SizedBox(
                          width: 290,
                          child: ElevatedButton(
                            onPressed: _nextPage,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.white,
                              foregroundColor: Colors.black,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(25),
                              ),
                              padding: EdgeInsets.symmetric(horizontal: 32, vertical: 16),
                            ),
                            child: Center(
                              child: Text(
                                'Empezar',
                                style: TextStyle(fontSize: 16),
                              ),
                            ),
                          ),
                        ),
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