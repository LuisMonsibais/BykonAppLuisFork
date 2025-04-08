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
      // Navegar a la siguiente pantalla después del onboarding
      print('Navegar a la siguiente pantalla');
      // Navigator.pushReplacement(...);
    }
  }

  void _skipOnboarding() {
    // Navegar a la siguiente pantalla omitiendo el onboarding
    print('Omitir onboarding');
    // Navigator.pushReplacement(...);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          // Background Image
          Positioned.fill(
            child: Image.asset(
              'assets/image.png', // Reemplaza con la ruta de tu imagen de fondo
              fit: BoxFit.contain,
            ),
          ),
          SafeArea(
            child: Column(
              children: [
                // Top Section (Status Bar and Progress Bar)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Text(
                            '••• 9:11',
                            style: TextStyle(color: Colors.white.withOpacity(0.7)),
                          ),
                          Spacer(),
                          Icon(Icons.signal_cellular_alt, color: Colors.white.withOpacity(0.7)),
                          SizedBox(width: 8),
                          Container(
                            padding: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                            decoration: BoxDecoration(
                              color: Colors.white.withOpacity(0.2),
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: Icon(Icons.battery_full, color: Colors.white),
                          ),
                        ],
                      ),
                      SizedBox(height: 16),
                      Row(
                        children: [
                          Expanded(
                            flex: _currentPage == 0 ? 3 : 1,
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            flex: _currentPage == 1 ? 2 : (_currentPage > 1 ? 2 : 1),
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.redAccent,
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                          SizedBox(width: 4),
                          Expanded(
                            flex: _currentPage == 2 ? 5 : (_currentPage < 2 ? 5 : 1),
                            child: Container(
                              height: 8,
                              decoration: BoxDecoration(
                                color: Colors.white.withOpacity(0.5),
                                borderRadius: BorderRadius.circular(4),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),

                // PageView for onboarding content
                Expanded(
                  child: PageView.builder(
                    controller: _pageController,
                    physics: NeverScrollableScrollPhysics(), // Disable swipe
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

                // Bottom Buttons
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