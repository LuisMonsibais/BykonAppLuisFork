import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mi_app/Object/User.dart';
import 'package:mi_app/VerificationCode/verification_code_screen.dart';
import '../ResetPassword/send_reset_code_screen.dart';
import '../main.dart'; // Ajusta la ruta a donde tengas tu HomeScreen
import '../Common/commonFunctions.dart';
import '../APIService/api_service.dart';
import '../APIService/ApiLoginError.dart';


Future<void> main() async {
  await dotenv.load(fileName: ".env"); // Cargar variables de entorno
  runApp(MyApp());
}
class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}
     
class _LoginScreenState extends State<LoginScreen> {
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController =  TextEditingController();



  bool _passwordVisible = false;
  bool _rememberMe = true;
  bool _showErrorMessagePassword = false;
  bool _showErrorMessageEmail = false;
  String _errorMessage = '';
  bool _hasInteractedWithEmail = false;


  @override
  void initState() {
    super.initState();
    // Escuchamos cambios en ambos campos para refrescar el botón
    _emailController.addListener(_onFieldChange);
    _passwordController.addListener(_onFieldChange);

   //_emailController.text="";// = "libertad.rivera@bykon.com.mx"; //"bertin.salas@bykon.com.mx";
   // _passwordController.text="";// = "%h4rRyP0tt3r%"; 
    
  }

  @override
  void dispose() {
    _emailController.dispose();
    _passwordController.dispose();

    super.dispose();
  }

  void _onFieldChange() {

    // Cada vez que cambian los campos, se reconstruye la UI
    setState(() {
      _errorMessage = '';
      _showErrorMessagePassword = false;
      _showErrorMessageEmail  = false;
      _hasInteractedWithEmail = true; });
  }

    // Verifica si el correo es una formula-bien-formada
     bool get _isMailWellDone =>
     _emailController.text.isNotEmpty && CommonFunctions.isValidEmail(_emailController.text); 

  // Verifica si ambos campos están llenos
  bool get _allFieldsFilled =>
      _emailController.text.isNotEmpty &&
      _passwordController.text.isNotEmpty;

//--------------------------------------------------
  Map<String, dynamic>? loginResponse;
  bool isLoading = false;
  // Función para manejar el login

//--------------------------------------------------


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

    // Determinar si están ambos campos llenos
    final bool allFieldsFilled = _allFieldsFilled;

   final bool emailFieldWellDoneFilled = _isMailWellDone;


    // Definir los colores actuales del botón según estado
    final Color currentButtonColor = allFieldsFilled && emailFieldWellDoneFilled ? buttonActiveColor : buttonInactiveColor;
    final Color currentButtonTextColor = allFieldsFilled && emailFieldWellDoneFilled? buttonActiveTextColor : buttonInactiveTextColor;

  if (_hasInteractedWithEmail && _emailController.text.length > 8 && !emailFieldWellDoneFilled) {
    setState(() {
      _showErrorMessageEmail  = true;
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
              const SizedBox(height: 15),//25
              Image.asset(
                'assets/ByKon Logo.png',
                width: 240, // Logo grande
              ),
              const SizedBox(height: 10),//20

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
                              // Texto: "Inicia sesión con tu correo de ByKon"
                              const Center(
                                child: Padding(
                                  padding: EdgeInsets.only(bottom: 36.0),
                                  child: Text(
                                    'Inicia sesión con tu correo\nde ByKon',
                                    textAlign: TextAlign.center,
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 28,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  ),
                                ),
                              ),

                              // Campo: Correo
                              Container(
                                height: 90.0,
                                margin: const EdgeInsets.only(bottom: 20.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 10),
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
                              
//_______________________________________//Control de correo mal escrito_____________________________________________     
                        if (_showErrorMessageEmail)//if (_errorMessage.isNotEmpty)                               
                            Padding(
                                    padding: const EdgeInsets.only(bottom: 5.0, left: 20.0),
                                    child: Row(
                                      children: [
                                        const Icon(Icons.warning, color: Colors.red, size: 16),
                                        const SizedBox(width: 8),
                                        Expanded(
                                          child: Text(
                                            _errorMessage, //'Verifica que tu correo sea correcto e inténtalo de nuevo.'
                                            style: const TextStyle(color: Color(0xFFFFCCD4), fontSize: 14),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                              // Campo: Contraseña
                              Container(
                                height: 90.0,
                                margin: const EdgeInsets.only(bottom: 8.0),
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 16, vertical: 16),
                                decoration: BoxDecoration(
                                  color: cardColor,
                                  borderRadius: BorderRadius.circular(8.0),
                                ),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: TextField(
                                        controller: _passwordController,
                                        obscureText: !_passwordVisible,
                                        style: const TextStyle(color: Colors.white),
                                        decoration: const InputDecoration(
                                          border: InputBorder.none,
                                          labelText: 'Contraseña',
                                          labelStyle: TextStyle(color: Colors.grey, fontSize: 24),
                                          hintText: 'abj162@',
                                          hintStyle: TextStyle(color: Colors.white70, fontSize: 18),
                                        ),
                                      ),
                                    ),
                                    IconButton(
                                      onPressed: () {
                                        setState(() {
                                          _passwordVisible = !_passwordVisible;
                                        });
                                      },
                                      icon: Icon(
                                        _passwordVisible
                                            ? Icons.visibility
                                            : Icons.visibility_off,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                    // Cuadro de texto para el mensaje de error de contraseña inc
                                if (_showErrorMessagePassword)
                                  Padding(
                                    padding: const EdgeInsets.only(top: 8.0, left: 10.0),
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
                              // Row: “Recuérdame” + “Olvidé mi contraseña”
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Row(
                                    children: [
                                      Checkbox(
                                        value: _rememberMe,
                                        onChanged: (bool? newValue) {
                                          setState(() {
                                            _rememberMe = newValue ?? false;
                                          });
                                        },
                                        // ignore: deprecated_member_use
                                        fillColor: MaterialStateProperty.all(
                                          const Color.fromARGB(89, 240, 175, 255),
                                        ),
                                        checkColor: const Color.fromARGB(255, 237, 166, 255),
                                      ),
                                      const Text(
                                        'Recuérdame',
                                        style: TextStyle(color: Colors.white),
                                      ),
                                    ],
                                  ),
                                  GestureDetector(
                                    onTap: () {
                                      // Acción "Olvidé mi contraseña"
                                  // Navegar a ChangePasswordScreen
                                      Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          //builder: (context) => ChangePasswordScreen(),
                                         builder: (context) => ResetCodeScreen(),
                                        ),
                                      );
                                    },
                                    child: const Text(
                                      'Olvidé mi contraseña',
                                      style: TextStyle(
                                        color: Colors.white,
                                        decoration: TextDecoration.underline,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),

                      // 2) Botón “Iniciar sesión” al final, dentro del contenedor negro
                      Padding(
                        padding: const EdgeInsets.all(24.0),
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
                              if (!allFieldsFilled) {
                                // Mostrar SnackBar: faltan datos
                                ScaffoldMessenger.of(context).showSnackBar(
                                  SnackBar(
                                    content: Row(
                                      children: const [
                                        Icon(Icons.warning, color: Colors.red, size: 16),
                                        SizedBox(width: 8),
                                        Expanded(
                                          child: Text('Por favor, llena correo y contraseña'),
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
                              } else {
                                final apiService = ApiService();
//--------------------------------------------------------------------------
                                final loginResponse = await apiService.login(            
                                 _emailController.text,
                                 _passwordController.text
                                          );
                                if (!loginResponse!.containsKey('error')) {//if loginResponse no tiene error => evalua si es primera o segunda vez
                                        
                                    setState(() { 
                                      _showErrorMessagePassword = false; });
                                       _errorMessage ='';
                                    final rememberChangePassword = User.instancia?.rememberChangePassword;                                       
                                    if (rememberChangePassword == true) {//EsLogin por primera vez =>generateCodeChangePassword
                                        final generateCodeResponse = await apiService.generateCodeChangePassword();
                                          if (!generateCodeResponse!.containsKey('error')) {
                                             // Navegar a la pantalla ChangePasswordScreen
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => SetCodeVerificationScreen(
                                                          email: _emailController.text,
                                                          token: generateCodeResponse['token'],
                                                          userCode: generateCodeResponse['user_code']
                                                        ),   
                                                      ),
                                                    );
                                                }
                                               );
                                            } else {
                                              // Mostrar un mensaje de error si el servicio falla para Login por primera vez
                                              ScaffoldMessenger.of(context).showSnackBar(
                                                SnackBar(
                                                  content: Text('Algo salió mal. Inténtalo de nuevo en unos momentos.'),
                                                ),
                                              );
                                            }
                                      } else {
                                      // Si no es Login por primera vez y es Login =200 => navegamos a Home
                                                WidgetsBinding.instance.addPostFrameCallback((_) {
                                                    Navigator.pushReplacement(
                                                      context,
                                                      MaterialPageRoute(
                                                        builder: (context) => HomeScreen(
                                                            //name: loginResponse.user.fullName, jobPosition: loginResponse.user.jobPosition
                                                        name: loginResponse['user']['full_name'], 
                                                        jobPosition:loginResponse['user']['job_position']
                                                        ),
                                                      ),
                                                    );
                                                }
                                               );
                                      } //end else no es Login por primera vez=> navegamos a Home*/
                                              } else{ //error en el servicio de login no es un 200                                              
                                                    final int responseStatusCode = loginResponse['error'];
                                                    // Manejo de errores
                                                    _errorMessage= handleLoginError(responseStatusCode); // Llama a la función que maneja los errores
                                                  _showErrorMessagePassword = false;
                                                  _showErrorMessageEmail = false;
                                                  if(responseStatusCode == 401){
                                                    setState(() {
                                                      _showErrorMessagePassword = true;
                                                    });
                                                  } else if(responseStatusCode == 452 || responseStatusCode == 550){
                                                     setState(() {
                                                      _showErrorMessageEmail = true;
                                                    });
                                                  } else { ScaffoldMessenger.of(context).showSnackBar(
                                                    SnackBar(
                                                      content: Row(
                                                        children: const [
                                                          Icon(Icons.warning, color: Colors.red, size: 16),
                                                          SizedBox(width: 8),
                                                          Expanded(
                                                            child: Text('Algo salió mal. Inténtalo de nuevo en unos momentos.'),
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
                              'Iniciar sesión',
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
