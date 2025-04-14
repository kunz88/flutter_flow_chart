import 'package:flutter/material.dart';

/// Defines grid parameters.
class GridBackgroundParams extends ChangeNotifier {
  /// [gridSquare] is the raw size of the grid square when scale is 1
  GridBackgroundParams({
    double gridSquare = 16.0,
    this.gridThickness = 0.7,
    this.secondarySquareStep = 5,
    this.backgroundColor = Colors.white,
    this.gridColor = Colors.black12,
    void Function(double scale)? onScaleUpdate,
  }) : rawGridSquareSize = gridSquare {
    if (onScaleUpdate != null) {
      _onScaleUpdateListeners.add(onScaleUpdate);
    }
  }

  ///
  factory GridBackgroundParams.fromMap(Map<String, dynamic> map) {
    final params = GridBackgroundParams(
      gridSquare: ((map['gridSquare'] ?? 20.0) as num).toDouble(),
      gridThickness: ((map['gridThickness'] ?? 0.7) as num).toDouble(),
      secondarySquareStep: map['secondarySquareStep'] as int? ?? 5,
      backgroundColor: Color(map['backgroundColor'] as int? ?? 0xFFFFFFFF),
      gridColor: Color(map['gridColor'] as int? ?? 0xFFFFFFFF),
    )
      ..scale = ((map['scale'] ?? 1.0) as num).toDouble()
      .._offset = Offset(
        ((map['offset.dx'] ?? 0.0) as num).toDouble(),
        ((map['offset.dy'] ?? 0.0) as num).toDouble(),
      );

    return params;
  }

  /// Unscaled size of the grid square
  /// i.e. the size of the square when scale is 1
  final double rawGridSquareSize;

  /// Thickness of lines.
  final double gridThickness;

  /// How many vertical or horizontal lines to draw the marked lines.
  final int secondarySquareStep;

  /// Grid background color.
  final Color backgroundColor;

  /// Grid lines color.
  final Color gridColor;

  /// offset to move the grid
  Offset _offset = Offset.zero;

  /// Scale of the grid.
  double scale = 1;

  /// Add listener for scaling
  void addOnScaleUpdateListener(void Function(double scale) listener) {
    _onScaleUpdateListeners.add(listener);
  }

  /// Remove listener for scaling
  void removeOnScaleUpdateListener(void Function(double scale) listener) {
    _onScaleUpdateListeners.remove(listener);
  }

  final List<void Function(double scale)> _onScaleUpdateListeners = [];

  ///
  set offset(Offset delta) {
    _offset += delta;
    notifyListeners();
  }

  ///
  void setScale(double factor, Offset focalPoint) {
    _offset = Offset(
      focalPoint.dx * (1 - factor),
      focalPoint.dy * (1 - factor),
    );
    scale = factor;

    for (final listener in _onScaleUpdateListeners) {
      listener(scale);
    }
    notifyListeners();
  }

  /// size of the grid square with scale applied
  double get gridSquare => rawGridSquareSize * scale;

  ///
  Offset get offset => _offset;

  ///
  Map<String, dynamic> toMap() {
    return {
      'offset.dx': _offset.dx,
      'offset.dy': _offset.dy,
      'scale': scale,
      'gridSquare': rawGridSquareSize,
      'gridThickness': gridThickness,
      'secondarySquareStep': secondarySquareStep,
      'backgroundColor': backgroundColor.value,
      'gridColor': gridColor.value,
    };
  }
}

/// Uses a CustomPainter to draw a grid with the given parameters
class GridBackground extends StatelessWidget {
  ///
  GridBackground({
    super.key,
    GridBackgroundParams? params,
  }) : params = params ?? GridBackgroundParams();

  /// Grid parameters
  final GridBackgroundParams params;

  @override
  Widget build(BuildContext context) {
    return ListenableBuilder(
      listenable: params,
      builder: (context, _) {
        return RepaintBoundary(
          child: CustomPaint(
            painter: _GridBackgroundPainter(
              params: params,
              dx: params.offset.dx,
              dy: params.offset.dy,
            ),
          ),
        );
      },
    );
  }
}

/* class _GridBackgroundPainter extends CustomPainter {
  _GridBackgroundPainter({
    required this.params,
    required this.dx,
    required this.dy,
  });

  final GridBackgroundParams params;
  final double dx;
  final double dy;

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()

      // Background
      ..color = params.backgroundColor;
    canvas.drawRect(
      Rect.fromPoints(Offset.zero, Offset(size.width, size.height)),
      paint,
    );

    // grid
    paint
      ..color = params.gridColor
      ..style = PaintingStyle.stroke;

    // Calculate the starting points for x and y
    final startX = dx % (params.gridSquare * params.secondarySquareStep);
    final startY = dy % (params.gridSquare * params.secondarySquareStep);

    // Calculate the number of lines to draw outside the visible area
    const extraLines = 2;

    // Draw vertical lines
    for (var x = startX - extraLines * params.gridSquare;
        x < size.width + extraLines * params.gridSquare;
        x += params.gridSquare) {
      paint.strokeWidth = ((x - startX) / params.gridSquare).round() %
                  params.secondarySquareStep ==
              0
          ? params.gridThickness * 2.0
          : params.gridThickness;
      canvas.drawLine(Offset(x, 0), Offset(x, size.height), paint);
    }

    // Draw horizontal lines
    for (var y = startY - extraLines * params.gridSquare;
        y < size.height + extraLines * params.gridSquare;
        y += params.gridSquare) {
      paint.strokeWidth = ((y - startY) / params.gridSquare).round() %
                  params.secondarySquareStep ==
              0
          ? params.gridThickness * 2.0
          : params.gridThickness;
      canvas.drawLine(Offset(0, y), Offset(size.width, y), paint);
    }
  }

  @override
  bool shouldRepaint(_GridBackgroundPainter oldDelegate) {
    debugPrint('shouldRepaint ${oldDelegate.dx} $dx ${oldDelegate.dy} $dy');
    return oldDelegate.dx != dx || oldDelegate.dy != dy;
  }
}
 */
class _GridBackgroundPainter extends CustomPainter {
  // offset verticale della griglia

  _GridBackgroundPainter({
    required this.params,
    required this.dx,
    required this.dy,
  });
  final GridBackgroundParams params;
  final double
      dx;
  final double dy;

  @override
  void paint(Canvas canvas, Size size) {
    // Disegna lo sfondo
    final backgroundPaint = Paint()..color = params.backgroundColor;
    canvas.drawRect(
      Rect.fromLTWH(0, 0, size.width, size.height),
      backgroundPaint,
    );

    // Imposta il paint per i punti della griglia
    final dotPaint = Paint()
      ..color = params.gridColor
      ..style = PaintingStyle.fill;

    // Definisci il raggio dei punti; lo puoi rendere proporzionale a gridThickness o a tuo piacimento
    final dotRadius = params.gridThickness * 1.5;

    // Calcola il punto di partenza.
    // Usando l'offset, otteniamo la posizione del primo punto in vista.
    // Se dx o dy sono diversi da zero, la griglia si sposta.
    // Prendiamo il modulo rispetto alla dimensione della cella per posizionare correttamente il primo punto.
    final modX = dx % params.gridSquare;
    final modY = dy % params.gridSquare;

    // Il primo punto visibile (in alto a sinistra) sarà spostato di -modX e -modY.
    final startX = -modX;
    final startY = -modY;

    // Calcoliamo quante colonne e righe sono necessarie per coprire l'intera area
    final columns = (size.width / params.gridSquare).ceil() + 1;
    final rows = (size.height / params.gridSquare).ceil() + 1;

    // Disegna un cerchio per ogni intersezione della griglia.
    for (var col = 0; col <= columns; col++) {
      for (var row = 0; row <= rows; row++) {
        final x = startX + col * params.gridSquare;
        final y = startY + row * params.gridSquare;

        // Facoltativo: disegna il punto solo se si trova (anche parzialmente) all'interno dell'area visibile
        if (x >= -dotRadius &&
            x <= size.width + dotRadius &&
            y >= -dotRadius &&
            y <= size.height + dotRadius) {
          canvas.drawCircle(Offset(x, y), dotRadius, dotPaint);
        }
      }
    }
  }

  @override
  bool shouldRepaint(covariant _GridBackgroundPainter oldDelegate) {
    return oldDelegate.dx != dx ||
        oldDelegate.dy != dy ||
        oldDelegate.params != params;
  }
}
