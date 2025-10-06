import 'package:google_mlkit_face_detection/google_mlkit_face_detection.dart';

import 'logger.dart';

abstract class FaceChallenges {
  final String instruction;
  FaceChallenges({this.instruction = ''});

  Future<bool> validate(Stream<Face> faceStream);

  static List<FaceChallenges> random(int totalChallenges) {
    if (totalChallenges <= 0) {
      throw ArgumentError('Jumlah tantangan harus lebih dari nol.');
    }
    if (totalChallenges > 6) {
      throw ArgumentError('Jumlah tantangan tidak boleh lebih dari 6.');
    }
    List<FaceChallenges> challenges = [
      SmileChallenge(),
      BlinkChallenge(),
      LookLeftChallenge(),
      LookRightChallenge(),
      LookUpChallenge(),
      LookDownChallenge(),
    ];
    challenges.shuffle();
    return challenges.take(totalChallenges).toList();
  }
}

class SmileChallenge extends FaceChallenges {
  SmileChallenge() : super(instruction: 'Silakan tersenyum ke kamera.');

  @override
  Future<bool> validate(faceStream) async {
    bool isSmiling = false;
    await for (Face face in faceStream) {
      clog('Tantangan Senyum: ${face.smilingProbability}');
      if (face.smilingProbability != null && face.smilingProbability! > 0.5) {
        isSmiling = true;
        break;
      }
    }
    return isSmiling;
  }
}

class BlinkChallenge extends FaceChallenges {
  BlinkChallenge() : super(instruction: 'Silakan kedipkan mata Anda.');

  @override
  Future<bool> validate(Stream<Face> faceStream) {
    bool isBlinking = false;
    return faceStream.firstWhere((face) {
      clog('Tantangan Kedip: mata kiri: ${face.leftEyeOpenProbability}, mata kanan: ${face.rightEyeOpenProbability}');
      if (face.leftEyeOpenProbability != null && face.leftEyeOpenProbability! < 0.5 && face.rightEyeOpenProbability != null && face.rightEyeOpenProbability! < 0.5) {
        isBlinking = true;
      }
      return isBlinking;
    }).then((_) => isBlinking);
  }
}

class LookLeftChallenge extends FaceChallenges {
  LookLeftChallenge() : super(instruction: 'Silakan lihat ke kiri Anda.');

  @override
  Future<bool> validate(Stream<Face> faceStream) {
    bool isLookingLeft = false;
    return faceStream.firstWhere((face) {
      clog('Tantangan Lihat Kiri: headEulerAngleY: ${face.headEulerAngleY}');
      if (face.headEulerAngleY != null && face.headEulerAngleY! > 18) {
        isLookingLeft = true;
      }
      return isLookingLeft;
    }).then((_) => isLookingLeft);
  }
}

class LookRightChallenge extends FaceChallenges {
  LookRightChallenge() : super(instruction: 'Silakan lihat ke kanan Anda.');

  @override
  Future<bool> validate(Stream<Face> faceStream) {
    bool isLookingRight = false;
    return faceStream.firstWhere((face) {
      clog('Tantangan Lihat Kanan: headEulerAngleY: ${face.headEulerAngleY}');
      if (face.headEulerAngleY != null && face.headEulerAngleY! < -18) {
        isLookingRight = true;
      }
      return isLookingRight;
    }).then((_) => isLookingRight);
  }
}

class LookUpChallenge extends FaceChallenges {
  LookUpChallenge() : super(instruction: 'Silakan lihat ke atas.');

  @override
  Future<bool> validate(Stream<Face> faceStream) {
    bool isLookingUp = false;
    return faceStream.firstWhere((face) {
      clog('Tantangan Lihat Atas: headEulerAngleX: ${face.headEulerAngleX}');
      if (face.headEulerAngleX != null && face.headEulerAngleX! > 18) {
        isLookingUp = true;
      }
      return isLookingUp;
    }).then((_) => isLookingUp);
  }
}

class LookDownChallenge extends FaceChallenges {
  LookDownChallenge() : super(instruction: 'Silakan lihat ke bawah.');

  @override
  Future<bool> validate(Stream<Face> faceStream) {
    bool isLookingDown = false;
    return faceStream.firstWhere((face) {
      clog('Tantangan Lihat Bawah: headEulerAngleX: ${face.headEulerAngleX}');
      if (face.headEulerAngleX != null && face.headEulerAngleX! < -18) {
        isLookingDown = true;
      }
      return isLookingDown;
    }).then((_) => isLookingDown);
  }
}
