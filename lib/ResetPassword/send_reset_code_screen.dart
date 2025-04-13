import 'package:flutter/material.dart';
import 'package:mi_app/VerificationCode/verification_code_screen.dart';
import '../Common/commonFunctions.dart';
import '../APIService/api_service.dart';
import '../APIService/ApiLoginError.dart';

class ResetCodeScreen extends StatefulWidget {
  const ResetCodeScreen({super.key});

  @override
  State<ResetCodeScreen> createState() => _ResetCodeScreenState();
}

class _ResetCodeScreenState extends State<ResetCodeScreen> {

final TextEditingController _emailController = TextEditingController();
///Users/vn55iez/BykonApp/mi_app/lib/VerificationCode/verification_code_screen.dart
  bool _showErrorMessage = false;
  String _errorMessage = '';
  bool _hasInteractedWithEmail = false;

  @override
  void initState() {
    super.initState();
    // Escuchamos cambios en ambos campos para refrescar el botón
    _emailController.addListener(_onFieldChange);
  }
  @override
  void dispose() {
  _emailController.dispose();
    super.dispose();
  }

  void _onFieldChange() {
    // Cada vez que cambian los campos, se reconstruye la UI
    setState(() {
    _errorMessage = '';
    _hasInteractedWithEmail = true; 
    _showErrorMessage  = false;});
  }
    
    // Verifica si el correo es una formula-bien-formada
     bool get _isMailWellDone =>
     _emailController.text.isNotEmpty && CommonFunctions.isValidEmail(_emailController.text); 

 Map<String, dynamic>? resetPasswordResponse;
  bool isLoading = false;


  @override
  Widget build(BuildContext context) {
        // -------------------------
    // Estilos / Colores
    // -------------------------
    final LinearGradient backgroundGradient = const LinearGradient(
      colors: [
        Color.fromARGB(255, 70, 0, 86), // Morado
        Color(0xFFFF0080),             // Rosa intenso
      ],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    // Contenedor negro para el formulario
    const Color containerColor = Colors.black;
    // "Tarjetas" más oscuras dentro del contenedor
    const Color cardColor = Color(0xFF1C1C1C);

    // Colores para el botón ACTIVO
    final Color buttonActiveColor = const Color.fromARGB(255, 246, 240, 255); 
    final Color buttonActiveTextColor = const Color.fromARGB(255, 51, 0, 54); 

    // Colores para el botón INACTIVO (disabled visual)
    final Color buttonInactiveColor = Colors.grey.shade600;
    final Color buttonInactiveTextColor = Colors.grey.shade300;

    final bool emailFieldWellDoneFilled = _isMailWellDone;

    // Definir los colores actuales del botón según estado
    final Color currentButtonColor = emailFieldWellDoneFilled ? buttonActiveColor : buttonInactiveColor;
    final Color currentButtonTextColor = emailFieldWellDoneFilled ? buttonActiveTextColor : buttonInactiveTextColor;

if (_hasInteractedWithEmail && _emailController.text.length>8 && !_isMailWellDone)
{
      setState(() {
      _showErrorMessage  = true;
      _errorMessage = 'Verifica que tu correo sea correcto e inténtalo de nuevo.';
    });
}

return Scaffold(
      // El fondo degradado ocupa toda la pantalla
      body: Container(
        decoration: BoxDecoration(
          gradient: backgroundGradient,
        ),
        // Column principal que separa:
        // 1) Zona superior con el logo
        // 2) Zona inferior (contenedor negro con formulario y botón)
        child: SafeArea(
          bottom: false,
          child: Column(
            children: [
              // -----------------------------------------------------------------
              // PARTE SUPERIOR: Logo grande con espacio
              // -----------------------------------------------------------------
              const SizedBox(height: 25),
              Image.asset(
                'assets/ByKon Logo.png',
                width: 240, // Logo grande
              ),
              const SizedBox(height: 20),

              // -----------------------------------------------------------------
              // PARTE INFERIOR: Contenedor negro con formulario + botón
              // -----------------------------------------------------------------
              Expanded(
                child: Container(
                  // Borde redondeado solo en la parte de arriba
                  decoration: const BoxDecoration(
                    color: containerColor,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(24),
                      topRight: Radius.circular(24),
                    ),
                  ),
                  // Para ubicar formulario y botón dentro
                  child: Column(
                    children: [
                      // 1) Formulario scrolleable
                      Expanded(
                        child: SingleChildScrollView(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 24,
                            vertical: 24,
                          ),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              // Texto: "¿Necesitas reestablecer tu contraseña?""
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 24.0),
                                  child: Text(
                                    '¿Necesitas reestablecer tu\ncontraseña?',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),
                              // Texto: 'Solo ingresa tu correo y te enviaremos un código para que puedas reestablecer tu contraseña.'
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 24.0),
                                  child: Text(
                                    'Solo ingresa tu correo Bykon y te\nenviaremos un código para que puedas\nreestablecer tu contraseña.',
                                    textAlign: TextAlign.left,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.normal,
                                    ),
                                  ),
                                ),
                              ),
                              // Campo: Correo
                              Container(
                                height: 90.0,
                                margin: const EdgeInsets.only(bottom: 5.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: TextField(
                                  controller: _emailController,
                                  style: const TextStyle(color: Colors.white),
                                  decoration: const InputDecoration(
                                    border: InputBorder.none,
                                    labelText: 'Correo',
                                    labelStyle: TextStyle(color: Colors.grey, fontSize: 24),
                                    hintText: 'ejemplo@bykon.com.mx',
                                    hintStyle: TextStyle(color: Colors.white70, fontSize: 18),
                                  ),
                                  onChanged: (value) {
                                      setState(() {
                                        _hasInteractedWithEmail = true;
                                      });
                                    },
                                ),
                              ),
                              ///Validación de correo bien formado
                              if (_showErrorMessage)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 20.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.warning, color: Colors.red, size: 16),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _errorMessage,
                                            style: const TextStyle(color: Color(0xFFFFCCD4), fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                            ],
                          ),
                        ),
                      ),                      
                      // 2) Botón “Enviar código” al final, dentro del contenedor negro
                      Padding(
                        padding: const EdgeInsets.all(24.0),//padding: EdgeInsets.only(bottom: 24.0),
                        child: SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                              backgroundColor: currentButtonColor,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(30),
                              ),
                              padding: const EdgeInsets.all(16),
                            ),
                            // El botón siempre tiene onPressed,
                            // pero si no están los campos llenos => SnackBar
                            onPressed: () async {
                              if ( !emailFieldWellDoneFilled) {
                                // Mostrar SnackBar: faltan datos
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: const [
                                        Icon(Icons.warning, color: Color.fromARGB(255, 255, 219, 166)),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text('Por favor, llena correo'),
                                        ),
                                      ],
                                    ),  //Row  
                                    backgroundColor: const Color(0xFF4D4D4D), // Fondo negro como en la imagen                                                                    backgroundColor: const Color(0xFF4D4D4D), // Fondo negro como en la imagen
                                    behavior: SnackBarBehavior.floating, 
                                        margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0), // Centrar horizontalmente y ajustar verticalmente
                                        shape: RoundedRectangleBorder(
                                          borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                                        ),// Flotante como en la imagen
                                  ),
                                );
                              } else {
//--------------------------------------------------------------------------
                              final apiService = ApiService();
                             final sendResetCodeResponse = await apiService.resetPassword(
                                                  _emailController.text
                                                );
                                    if (!sendResetCodeResponse!.containsKey( 'error')) {     
                                         setState(() {
                                               _showErrorMessage = false;                                               
                                            });    
                                          _errorMessage ='';        
                                // Están completos => navegamos a SetCodeVerificationScreen
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => SetCodeVerificationScreen(
                                                          email: _emailController.text,//"libertad.rivera@bykon.com.mx",
                                                          token: sendResetCodeResponse['token'],//sendResetCodeResponse.token ,//"token",
                                                          userCode: sendResetCodeResponse['user_code']//sendResetCodeResponse.userCode,//"userCode",
                                                        ),   
                                                      ),
                                                    );
                                                }
                                               );
                                              } else {
                                                final int responseStatusCode = sendResetCodeResponse['error'];
                                                _errorMessage= handleLoginError(responseStatusCode);
                                                _showErrorMessage = false;
                                                // email inactivo o invalid                                            
                                                    if(responseStatusCode == 452 || responseStatusCode == 550){ 
                                                      setState(() {
                                                        _showErrorMessage = true;
                                                      });
                                                    } else { //no se pudo enviar el codigo o error desconocido
                                                        ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Row(
                                                        children: const [
                                                          Icon(Icons.warning, color: Colors.red, size: 16),
                                                          SizedBox(width: 8),
                                                          Expanded(
                                                            child: Text('Algo salió mal al enviarte el código de verificación. Inténtalo de nuevo.'),
                                                          ),
                                                        ],
                                                      ),
                                                      backgroundColor: const Color(0xFF4D4D4D), // Fondo negro como en la imagen
                                                      behavior: SnackBarBehavior.floating, 
                                                          margin: const EdgeInsets.symmetric(horizontal: 50.0, vertical: 20.0), // Centrar horizontalmente y ajustar verticalmente
                                                          shape: RoundedRectangleBorder(
                                                            borderRadius: BorderRadius.circular(10.0), // Bordes redondeados
                                                          ),// Flotante como en la imagen
                                                    ),
                                                  );
                                                    }
                                              }
                                            }
                                          },
//--------------------------------------------------------------------------       
                            child: Text(
                              'Enviar código',
                              style: TextStyle(
                                color: currentButtonTextColor,
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }


  
}


