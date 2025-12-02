import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:zoom_clone/controlers/google_sing_in_controler.dart';
import 'package:zoom_clone/controlers/user_profiledata_save_controller.dart';
import 'package:zoom_clone/wrapper.dart';

class ShowDilogWidget extends StatefulWidget {
  const ShowDilogWidget(
    this.tital,
    this.warningMassage,
    this.function, {
    super.key,
  });
  final String tital;
  final String warningMassage;
  final Future<bool> Function() function;

  @override
  State<StatefulWidget> createState() {
    return _ShowDilogWidgetState();
  }
}

class _ShowDilogWidgetState extends State<ShowDilogWidget> {
  UserProfiledataSaveController userProfileInstens = Get.find();
  GoogleSingInControler googleInstens = Get.put(GoogleSingInControler());

  // Controllers for text fields
  final TextEditingController _passwordController = TextEditingController();
  final TextEditingController _otpController = TextEditingController();

  // State variables
  bool _isPasswordVisible = false;
  bool _isLoading = false;
  String _authMethod = 'password'; // 'password', 'google', 'phone'
  bool _otpSent = false;
  String? _verificationId;
  String? _errorMessage;

  @override
  void initState() {
    super.initState();
    _determineAuthMethod();
  }

  @override
  void dispose() {
    _passwordController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _determineAuthMethod() {
    // Determine the authentication method based on user's sign-in method
    final user = FirebaseAuth.instance.currentUser;
    if (user != null) {
      for (var provider in user.providerData) {
        if (provider.providerId == 'google.com') {
          _authMethod = 'google';
          break;
        } else if (provider.providerId == 'phone') {
          _authMethod = 'phone';
          break;
        } else if (provider.providerId == 'password') {
          _authMethod = 'password';
          break;
        }
      }
    }
  }

  Future<void> _reauthenticateAndProceed() async {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      bool success = false;

      switch (_authMethod) {
        case 'password':
          success = await _reauthenticateWithPassword();
          break;
        case 'google':
          success = await _reauthenticateWithGoogle();
          break;
        case 'phone':
          if (_otpSent) {
            success = await _verifyOTP();
          } else {
            await _sendOTP();
            return; // Don't proceed yet, wait for OTP
          }
          break;
      }

      if (success) {
        // Proceed with the original function
        widget.function();
        if (mounted) {
          Navigator.pop(context);
        }
      }
    } catch (e) {
      setState(() {
        _errorMessage = e.toString();
      });
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  Future<bool> _reauthenticateWithPassword() async {
    if (_passwordController.text.trim().isEmpty) {
      throw Exception('Please enter your password');
    }

    final user = FirebaseAuth.instance.currentUser;
    final credential = EmailAuthProvider.credential(
      email: user!.email!,
      password: _passwordController.text.trim(),
    );

    await user.reauthenticateWithCredential(credential);
    return true;
  }

  Future<bool> _reauthenticateWithGoogle() async {
    return await GoogleSingInControler.instence.googleSignIn();
    // Call your existing Google sign-in method
    // You mentioned you'll handle this, so I'm leaving it as a placeholder
    // Replace this with your actual Google reauthentication logic

    // Example:
    // final googleCredential = await yourGoogleSignInMethod();
    // final user = FirebaseAuth.instance.currentUser;
    // await user!.reauthenticateWithCredential(googleCredential);

    // throw UnimplementedError('Google reauthentication not implemented yet');
  }

  Future<void> _sendOTP() async {
    final user = FirebaseAuth.instance.currentUser;
    final phoneNumber = user?.phoneNumber;

    if (phoneNumber == null) {
      throw Exception('No phone number found');
    }

    await FirebaseAuth.instance.verifyPhoneNumber(
      phoneNumber: phoneNumber,
      verificationCompleted: (PhoneAuthCredential credential) async {
        await user!.reauthenticateWithCredential(credential);
        widget.function();
        if (mounted) {
          Navigator.pop(context);
        }
      },
      verificationFailed: (FirebaseAuthException e) {
        throw Exception(e.message ?? 'Failed to send OTP');
      },
      codeSent: (String verificationId, int? resendToken) {
        setState(() {
          _verificationId = verificationId;
          _otpSent = true;
        });
      },
      codeAutoRetrievalTimeout: (String verificationId) {
        _verificationId = verificationId;
      },
    );
  }

  Future<bool> _verifyOTP() async {
    if (_otpController.text.trim().isEmpty) {
      throw Exception('Please enter the OTP');
    }

    final credential = PhoneAuthProvider.credential(
      verificationId: _verificationId!,
      smsCode: _otpController.text.trim(),
    );

    final user = FirebaseAuth.instance.currentUser;
    await user!.reauthenticateWithCredential(credential);
    return true;
  }

  Widget _buildReauthenticationWidget() {
    final colorScheme = Theme.of(context).colorScheme;

    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const SizedBox(height: 16),

        // Info message
        Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: colorScheme.primaryContainer.withValues(alpha: 0.3),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Row(
            children: [
              Icon(Icons.info_outline, color: colorScheme.primary, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  'For security, please verify your identity',
                  style: TextStyle(
                    color: colorScheme.onSurfaceVariant,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
        ),

        const SizedBox(height: 16),

        // Authentication method specific UI
        if (_authMethod == 'password') _buildPasswordField(colorScheme),
        if (_authMethod == 'phone') _buildPhoneAuthField(colorScheme),
        if (_authMethod == 'google') _buildGoogleAuthField(colorScheme),

        // Error message
        if (_errorMessage != null) ...[
          const SizedBox(height: 12),
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: colorScheme.errorContainer.withValues(alpha: 0.3),
              borderRadius: BorderRadius.circular(6),
            ),
            child: Text(
              _errorMessage!,
              style: TextStyle(color: colorScheme.error, fontSize: 12),
            ),
          ),
        ],
      ],
    );
  }

  Widget _buildPasswordField(ColorScheme colorScheme) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter your password',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _passwordController,
          obscureText: !_isPasswordVisible,
          decoration: InputDecoration(
            hintText: 'Password',
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
            suffixIcon: IconButton(
              icon: Icon(
                _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                color: colorScheme.onSurfaceVariant,
              ),
              onPressed: () {
                setState(() {
                  _isPasswordVisible = !_isPasswordVisible;
                });
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildPhoneAuthField(ColorScheme colorScheme) {
    if (!_otpSent) {
      return Column(
        children: [
          Text(
            'We\'ll send an OTP to your registered phone number',
            style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
            textAlign: TextAlign.center,
          ),
        ],
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Enter the OTP sent to your phone',
          style: TextStyle(
            color: colorScheme.onSurface,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
        ),
        const SizedBox(height: 8),
        TextField(
          controller: _otpController,
          keyboardType: TextInputType.number,
          maxLength: 6,
          decoration: InputDecoration(
            hintText: '000000',
            hintStyle: TextStyle(color: colorScheme.onSurfaceVariant),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.outline),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(8),
              borderSide: BorderSide(color: colorScheme.primary),
            ),
            counterText: '',
          ),
        ),
      ],
    );
  }

  Widget _buildGoogleAuthField(ColorScheme colorScheme) {
    return Column(
      children: [
        Icon(Icons.account_circle, color: colorScheme.primary, size: 48),
        const SizedBox(height: 8),
        Text(
          'Sign in with Google to continue',
          style: TextStyle(color: colorScheme.onSurfaceVariant, fontSize: 14),
          textAlign: TextAlign.center,
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final colorScheme = Theme.of(context).colorScheme;

    return AlertDialog(
      backgroundColor: colorScheme.surface,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      title: Row(
        children: [
          Icon(Icons.warning_outlined, color: colorScheme.error),
          const SizedBox(width: 10),
          Expanded(
            child: Text(
              '${widget.tital}?',
              style: TextStyle(color: colorScheme.onSurface),
            ),
          ),
        ],
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(
            widget.warningMassage,
            style: TextStyle(color: colorScheme.onSurfaceVariant),
          ),

          // Show reauthentication UI if required
          Obx(() {
            if (userProfileInstens.requiresRecentLogin.value) {
              return _buildReauthenticationWidget();
            }
            return const SizedBox.shrink();
          }),
        ],
      ),
      actions: [
        TextButton(
          onPressed: _isLoading ? null : () => Navigator.pop(context),
          child: Text(
            'Cancel',
            style: TextStyle(
              color: _isLoading
                  ? colorScheme.onSurfaceVariant.withValues(alpha: 0.5)
                  : colorScheme.onSurfaceVariant,
            ),
          ),
        ),
        TextButton(
          onPressed: _isLoading
              ? null
              : () async {
                  if (userProfileInstens.requiresRecentLogin.value) {
                    await _reauthenticateAndProceed();
                  } else {
                    await widget.function();
                    Get.offAll(() => Wrapper());
                  }
                },
          child:
              _isLoading ||
                  userProfileInstens.accoundDelitting.value ||
                  googleInstens.isSingOut.value
              ? SizedBox(
                  width: 16,
                  height: 16,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    valueColor: AlwaysStoppedAnimation<Color>(
                      colorScheme.primary,
                    ),
                  ),
                )
              : Text(
                  userProfileInstens.requiresRecentLogin.value
                      ? (_authMethod == 'phone' && !_otpSent
                            ? 'Send OTP'
                            : 'Verify')
                      : widget.tital,
                  style: TextStyle(color: colorScheme.error),
                ),
        ),
      ],
    );
  }
}
