import 'package:app/main.dart';
import 'package:flutter/material.dart';
import 'dart:math';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;

  @override
  void initState() {
    super.initState();
    
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat();

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.5, curve: Curves.easeOut),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.8, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: const Interval(0.0, 0.7, curve: Curves.easeOutBack),
      ),
    );

    Future.delayed(const Duration(seconds: 3), () {
      Navigator.of(context).pushReplacement(
        MaterialPageRoute(builder: (context) => const MainScreen()),
      );
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;
    final size = MediaQuery.of(context).size;

    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        color: isDark ? const Color(0xFF0A0A0A) : const Color(0xFFFAFAFA),
        child: Stack(
          children: [
            _NodeNetwork(size: size, isDark: isDark),
            
            Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  AnimatedBuilder(
                    animation: _controller,
                    builder: (context, child) {
                      return Transform.scale(
                        scale: _scaleAnimation.value,
                        child: Container(
                          width: size.width * 0.2,
                          height: size.width * 0.2,
                          decoration: BoxDecoration(
                            color: Colors.amber[600],
                            shape: BoxShape.circle,
                          ),
                          child: Icon(
                            Icons.location_on,
                            size: size.width * 0.1,
                            color: Colors.white,
                          ),
                        ),
                      );
                    },
                  ),
                  
                  const SizedBox(height: 40),
                  
                  AnimatedBuilder(
                    animation: _fadeAnimation,
                    builder: (context, child) {
                      return Opacity(
                        opacity: _fadeAnimation.value,
                        child: Column(
                          children: [
                            Text(
                              'Map Navigator',
                              style: TextStyle(
                                fontSize: size.width * 0.07,
                                fontWeight: FontWeight.w300,
                                color: isDark ? Colors.white : Colors.black87,
                                letterSpacing: 4,
                              ),
                            ),
                            const SizedBox(height: 8),
                            Text(
                              'навигация',
                              style: TextStyle(
                                fontSize: size.width * 0.03,
                                fontWeight: FontWeight.w300,
                                color: isDark ? Colors.grey[500] : Colors.grey[600],
                                letterSpacing: 6,
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _NodeNetwork extends StatefulWidget {
  final Size size;
  final bool isDark;

  const _NodeNetwork({required this.size, required this.isDark});

  @override
  State<_NodeNetwork> createState() => _NodeNetworkState();
}

class _NodeNetworkState extends State<_NodeNetwork> with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  final List<_Node> _nodes = [];
  final Random _random = Random();

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(seconds: 2),
      vsync: this,
    )..repeat();

    for (int i = 0; i < 12; i++) {
      _nodes.add(_Node(
        x: _random.nextDouble() * widget.size.width,
        y: _random.nextDouble() * widget.size.height,
        radius: 2 + _random.nextDouble() * 3,
        speed: 0.3 + _random.nextDouble() * 0.5,
        angle: _random.nextDouble() * 2 * pi,
      ));
    }

    WidgetsBinding.instance.addPostFrameCallback((_) {
      setState(() {});
    });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: _controller,
      builder: (context, child) {
        _updateNodes();
        return CustomPaint(
          painter: _NodePainter(
            nodes: _nodes,
            isDark: widget.isDark,
            size: widget.size,
          ),
          size: widget.size,
        );
      },
    );
  }

  void _updateNodes() {
    for (var node in _nodes) {
      node.x += cos(node.angle) * node.speed * 0.5;
      node.y += sin(node.angle) * node.speed * 0.5;

      if (node.x < 0) node.x = widget.size.width;
      if (node.x > widget.size.width) node.x = 0;
      if (node.y < 0) node.y = widget.size.height;
      if (node.y > widget.size.height) node.y = 0;
    }
  }
}

class _Node {
  double x;
  double y;
  final double radius;
  final double speed;
  final double angle;

  _Node({
    required this.x,
    required this.y,
    required this.radius,
    required this.speed,
    required this.angle,
  });
}

class _NodePainter extends CustomPainter {
  final List<_Node> nodes;
  final bool isDark;
  final Size size;

  _NodePainter({
    required this.nodes,
    required this.isDark,
    required this.size,
  });

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()
      ..color = isDark 
          ? Colors.amber[600]!.withOpacity(0.6)
          : Colors.amber[600]!.withOpacity(0.4)
      ..style = PaintingStyle.fill;

    final linePaint = Paint()
      ..color = isDark 
          ? Colors.amber[600]!.withOpacity(0.15)
          : Colors.amber[600]!.withOpacity(0.1)
      ..strokeWidth = 0.5
      ..style = PaintingStyle.stroke;

    for (int i = 0; i < nodes.length; i++) {
      for (int j = i + 1; j < nodes.length; j++) {
        final dx = nodes[i].x - nodes[j].x;
        final dy = nodes[i].y - nodes[j].y;
        final distance = sqrt(dx * dx + dy * dy);
        
        if (distance < 180) {
          final opacity = (1 - distance / 180) * 0.5;
          linePaint.color = isDark 
              ? Colors.amber[600]!.withOpacity(0.1 * opacity)
              : Colors.amber[600]!.withOpacity(0.08 * opacity);
          canvas.drawLine(
            Offset(nodes[i].x, nodes[i].y),
            Offset(nodes[j].x, nodes[j].y),
            linePaint,
          );
        }
      }
    }

    for (var node in nodes) {
      canvas.drawCircle(
        Offset(node.x, node.y),
        node.radius,
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(_NodePainter oldDelegate) => true;
}