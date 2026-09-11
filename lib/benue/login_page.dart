import 'package:flutter/material.dart';

import 'campaign_identity.dart';
import 'domain/models.dart';
import 'session.dart';
import 'widgets.dart';

class CampaignLoginPage extends StatefulWidget {
  const CampaignLoginPage({super.key});

  @override
  State<CampaignLoginPage> createState() => _CampaignLoginPageState();
}

class _CampaignLoginPageState extends State<CampaignLoginPage> {
  final operatorController = TextEditingController();
  final accessIdController = TextEditingController();
  final passwordController = TextEditingController();

  CampaignRole selectedRole = CampaignRole.directorGeneral;
  bool obscurePassword = true;
  bool rememberDevice = true;

  @override
  void dispose() {
    operatorController.dispose();
    accessIdController.dispose();
    passwordController.dispose();
    super.dispose();
  }

  void _signIn() {
    final operator = operatorController.text.trim();
    CampaignSession.of(context, listen: false).signIn(
      role: selectedRole,
      operatorName: operator.isEmpty ? roleLabel(selectedRole) : operator,
    );
  }

  @override
  Widget build(BuildContext context) => Scaffold(
        backgroundColor: const Color(0xFFF2F5F2),
        body: SafeArea(
          child: LayoutBuilder(
            builder: (context, c) {
              final wide = c.maxWidth >= 980;
              if (wide) {
                return Row(
                  children: [
                    Expanded(flex: 11, child: _campaignPanel()),
                    Expanded(flex: 13, child: _loginPanel()),
                  ],
                );
              }
              return ListView(
                padding: const EdgeInsets.all(18),
                children: [
                  SizedBox(height: 360, child: _campaignPanel(compact: true)),
                  const SizedBox(height: 16),
                  _loginPanel(compact: true),
                ],
              );
            },
          ),
        ),
      );

  Widget _campaignPanel({bool compact = false}) => Container(
        margin: EdgeInsets.all(compact ? 0 : 18),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(30),
          gradient: const LinearGradient(
            colors: [Color(0xFF052A18), Color(0xFF0B7A3B)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          boxShadow: [
            BoxShadow(
              color: const Color(0xFF0B7A3B).withValues(alpha: .18),
              blurRadius: 40,
              offset: const Offset(0, 18),
            ),
          ],
        ),
        child: Stack(
          children: [
            Positioned(
              right: -80,
              top: -90,
              child: Container(
                width: 280,
                height: 280,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: Colors.white.withValues(alpha: .05),
                ),
              ),
            ),
            Positioned(
              left: -100,
              bottom: -130,
              child: Container(
                width: 340,
                height: 340,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: pdpRed.withValues(alpha: .12),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.all(compact ? 24 : 42),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const PdpLogo(),
                      const SizedBox(width: 12),
                      const Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            'POLISPHERE BENUE',
                            style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              letterSpacing: .8,
                            ),
                          ),
                          SizedBox(height: 2),
                          Text(
                            'Campaign Command Platform',
                            style: TextStyle(color: Colors.white60, fontSize: 12),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const Spacer(),
                  Row(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CandidatePortrait(size: compact ? 105 : 148, borderWidth: 4),
                      const SizedBox(width: 20),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                              decoration: BoxDecoration(
                                color: Colors.white.withValues(alpha: .12),
                                borderRadius: BorderRadius.circular(999),
                                border: Border.all(color: Colors.white24),
                              ),
                              child: const Text(
                                'BENUE STATE',
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 10,
                                  fontWeight: FontWeight.w900,
                                  letterSpacing: 1.2,
                                ),
                              ),
                            ),
                            const SizedBox(height: 12),
                            const Text(
                              CampaignIdentity.candidateName,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 25,
                                height: 1.05,
                                fontWeight: FontWeight.w900,
                              ),
                            ),
                            const SizedBox(height: 6),
                            const Text(
                              CampaignIdentity.candidateTitle,
                              style: TextStyle(
                                color: Colors.white70,
                                fontSize: 13,
                                fontWeight: FontWeight.w700,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 28),
                  if (!compact) ...[
                    const Text(
                      'Campaign intelligence, field operations, communications and election readiness in one command centre.',
                      style: TextStyle(color: Colors.white70, fontSize: 15, height: 1.5),
                    ),
                    const SizedBox(height: 24),
                  ],
                  Wrap(
                    spacing: 8,
                    runSpacing: 8,
                    children: const [
                      _CampaignStat('23', 'LGAs'),
                      _CampaignStat('276', 'Wards'),
                      _CampaignStat('5,102', 'Polling Units'),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      );

  Widget _loginPanel({bool compact = false}) => Center(
        child: SingleChildScrollView(
          padding: EdgeInsets.symmetric(
            horizontal: compact ? 4 : 52,
            vertical: compact ? 10 : 34,
          ),
          child: ConstrainedBox(
            constraints: const BoxConstraints(maxWidth: 760),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Welcome to Campaign Command',
                  style: TextStyle(
                    fontSize: 30,
                    color: ink,
                    fontWeight: FontWeight.w900,
                    letterSpacing: -.6,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Choose your role and enter your campaign workspace.',
                  style: TextStyle(color: muted, height: 1.5),
                ),
                const SizedBox(height: 24),
                const Text('Select role',
                    style: TextStyle(color: ink, fontWeight: FontWeight.w900, fontSize: 15)),
                const SizedBox(height: 12),
                _roleGrid(),
                const SizedBox(height: 22),
                Row(
                  children: [
                    Expanded(
                      child: TextField(
                        controller: operatorController,
                        decoration: _inputDecoration(
                          'Your name',
                          'Enter your name',
                          Icons.person_outline_rounded,
                        ),
                      ),
                    ),
                    if (!compact) ...[
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          controller: accessIdController,
                          decoration: _inputDecoration(
                            'Access ID / phone',
                            'Enter access ID or phone',
                            Icons.badge_outlined,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
                if (compact) ...[
                  const SizedBox(height: 12),
                  TextField(
                    controller: accessIdController,
                    decoration: _inputDecoration(
                      'Access ID / phone',
                      'Enter access ID or phone',
                      Icons.badge_outlined,
                    ),
                  ),
                ],
                const SizedBox(height: 12),
                TextField(
                  controller: passwordController,
                  obscureText: obscurePassword,
                  onSubmitted: (_) => _signIn(),
                  decoration: _inputDecoration(
                    'Password',
                    'Enter password',
                    Icons.lock_outline_rounded,
                  ).copyWith(
                    suffixIcon: IconButton(
                      onPressed: () => setState(() => obscurePassword = !obscurePassword),
                      icon: Icon(obscurePassword
                          ? Icons.visibility_outlined
                          : Icons.visibility_off_outlined),
                    ),
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Checkbox(
                      value: rememberDevice,
                      onChanged: (value) => setState(() => rememberDevice = value ?? false),
                    ),
                    const Text('Remember this device',
                        style: TextStyle(color: ink, fontWeight: FontWeight.w700)),
                    const Spacer(),
                    TextButton(
                      onPressed: () {},
                      child: const Text('Forgot access?'),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                SizedBox(
                  width: double.infinity,
                  height: 54,
                  child: FilledButton.icon(
                    onPressed: _signIn,
                    icon: const Icon(Icons.login_rounded),
                    label: Text('Enter as ${roleLabel(selectedRole)}'),
                    style: FilledButton.styleFrom(
                      backgroundColor: pdpGreen,
                      foregroundColor: Colors.white,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      textStyle: const TextStyle(fontWeight: FontWeight.w900),
                    ),
                  ),
                ),
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF5F8F5),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: const Color(0xFFE0E8E2)),
                  ),
                  child: const Row(
                    children: [
                      Icon(Icons.shield_outlined, size: 18, color: pdpGreen),
                      SizedBox(width: 9),
                      Expanded(
                        child: Text(
                          'Authorized campaign personnel only.',
                          style: TextStyle(color: ink, fontSize: 12, fontWeight: FontWeight.w700),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      );

  Widget _roleGrid() => LayoutBuilder(
        builder: (context, c) {
          final columns = c.maxWidth > 680 ? 4 : c.maxWidth > 430 ? 3 : 2;
          const gap = 9.0;
          final width = (c.maxWidth - gap * (columns - 1)) / columns;
          return Wrap(
            spacing: gap,
            runSpacing: gap,
            children: CampaignRole.values.map((role) {
              final active = role == selectedRole;
              return InkWell(
                borderRadius: BorderRadius.circular(14),
                onTap: () => setState(() => selectedRole = role),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 160),
                  width: width,
                  constraints: const BoxConstraints(minHeight: 96),
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: active ? const Color(0xFFE8F4EB) : Colors.white,
                    borderRadius: BorderRadius.circular(14),
                    border: Border.all(
                      color: active ? pdpGreen : const Color(0xFFDDE5DF),
                      width: active ? 1.5 : 1,
                    ),
                    boxShadow: active
                        ? [
                            BoxShadow(
                              color: pdpGreen.withValues(alpha: .10),
                              blurRadius: 16,
                              offset: const Offset(0, 6),
                            )
                          ]
                        : null,
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Icon(roleIcon(role),
                              color: active ? pdpGreen : muted, size: 21),
                          const Spacer(),
                          if (active)
                            const Icon(Icons.check_circle_rounded,
                                color: pdpGreen, size: 18),
                        ],
                      ),
                      const SizedBox(height: 10),
                      Text(
                        roleLabel(role),
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: TextStyle(
                          color: active ? pdpGreenDark : ink,
                          fontSize: 11.5,
                          height: 1.15,
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ],
                  ),
                ),
              );
            }).toList(),
          );
        },
      );

  InputDecoration _inputDecoration(
    String label,
    String hint,
    IconData icon,
  ) =>
      InputDecoration(
        labelText: label,
        hintText: hint,
        prefixIcon: Icon(icon),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDDE5DF)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: Color(0xFFDDE5DF)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(14),
          borderSide: const BorderSide(color: pdpGreen, width: 1.5),
        ),
      );
}

class _CampaignStat extends StatelessWidget {
  const _CampaignStat(this.value, this.label);
  final String value;
  final String label;

  @override
  Widget build(BuildContext context) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 13, vertical: 10),
        decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: .10),
          borderRadius: BorderRadius.circular(13),
          border: Border.all(color: Colors.white12),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(value,
                style: const TextStyle(
                    color: Colors.white, fontWeight: FontWeight.w900)),
            const SizedBox(width: 6),
            Text(label,
                style: const TextStyle(color: Colors.white60, fontSize: 11)),
          ],
        ),
      );
}
